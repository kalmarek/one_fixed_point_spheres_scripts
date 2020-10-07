# To load this file from the project directory (assuming GAP is launched in this directory), call
# Read( Filename( [DirectoryCurrent()], "level_3_functions.g" ) );

Read( Filename( [DirectoryCurrent()], "level_2_functions.g" ) );


# Let G be a group.
# The function below computes the list MN_one( givenDim, G ) of real G-modules - for the explanation,
# see my PhD thesis [2], ODNOSNIK. We know that the modules in that list cannot occur at tangent
# spaces at fixed point for one fixed point actions of G on spheres of the same dimension (implicitly given).
# Apart from G, the additional parameters are:
#	- modulesNotExcludedOdd - list MN_odd( givenDim, G ) of real G-modules of the same dimension (implicitly given),
# - subgroupTriplesTypeB - the second list from the output of SubgroupTriples.
ModulesNotExcludedOne := function( G, modulesNotExcludedOdd, subgroupTriplesTypeB )
	local realModule, triple, dimH1, dimH2, dimP, realIrr, index2SubgroupIntersection, result;
	index2SubgroupIntersection := Intersection( Index2Subgroups( G ) );
	realIrr := RealIrreducibles( G );
	result := Set( modulesNotExcludedOdd );
	for realModule in modulesNotExcludedOdd do
		for triple in subgroupTriplesTypeB do
			dimH1 := FixedPointDimensionRealModule( realModule, Representative( triple[1] ),
																							G, realIrr.complexEquivalent );
			dimH2 := FixedPointDimensionRealModule( realModule, Representative( triple[2] ),
																							G, realIrr.complexEquivalent );
			dimP := FixedPointDimensionRealModule( realModule, Representative( triple[3] ),
																							G, realIrr.complexEquivalent );
			if dimH1+dimH2 = dimP and dimH1*dimH2 > 0 then
				RemoveSet( result, realModule );
				break;
			fi;
		od;
		if Size( index2SubgroupIntersection ) > 0 then
			if FixedPointDimensionRealModule( realModule, index2SubgroupIntersection,
																				G, realIrr.complexEquivalent ) > 0 then
				RemoveSet( result, realModule );
			fi;
		fi;
	od;
	return result;
end;

# Let G be a group and realIrreducibles be
#	the list of the characters of the real irreducible representations of G.
# The function below computes the rank of the matrix D_G,
#	for the explanation see my PhD thesis [2], pp. 40 ODNOSNIK.
RankD := function( G, realIrreducibles, complexEquivalent )
	local D;
	D := List( Filtered( List( ConjugacyClassesSubgroups( G ), cl -> Representative( cl ) ),
	 																H -> IsPGroup( H ) ),
							 										P -> List( realIrreducibles,
							 			 												 irr -> FixedPointDimensionRealModule( [[irr,1]], P, G,
																						 																				complexEquivalent ) ) );
	return RankMat( D );
end;

# Let G be a group.
# The procedure below (which is not a function in the mathematical sense)
# displays the fixed point dimensions for sugroups of G acting on real irreducible G-modules.
TableFixedPointDimension := function( G )
	local cl, ir, i, realIrr;
	Print( "      " );
	i := 1;
	for cl in ConjugacyClassesSubgroups( G ) do
		Print( i, "  " );
		i := i+1;
	od;
	Print( "\n\n" );
	realIrr := RealIrreducibles( G );
	for ir in realIrr.realIrreducibles do
		Print( "X.", LookupDictionary( realIrr.realIrrNr, ir ), " " );
		Display( List( ConjugacyClassesSubgroups( G ),
		 							 cl -> FixedPointDimensionRealModule( [[ir,1]], Representative( cl ), G ) ) );
	od;
	Print( "\n" );
	i := 1;
	for cl in ConjugacyClassesSubgroups( G ) do
		Print( i, " = ", StructureDescription( Representative( cl ) ), "\n" );
		i := i+1;
	od;
	Print( "\n\n" );
end;