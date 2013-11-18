module analysis::UnitSize

import lang::java::jdt::m3::AST;
import IO;
import util::Math;

import extract::UnitSize;

// calculate unit size rating
str unitSizeRating(list[Declaration] methodAsts, int totalProductionLoc) {
	list[int] unitSizeUnits = unitSizePerUnit(methodAsts);
	
	// filtering the risk into moderate, high and very high risk
	list[int] moderateRisk = [x | x <- unitSizeUnits, x > 20, x <= 50];
	list[int] highRisk = [x | x <- unitSizeUnits, x > 50, x <= 100];
	list[int] veryHighRisk = [x | x <- unitSizeUnits, x > 100];
	
	// calculating total line of code per risk
	int moderateRiskTotalLoc = (0 | it + x | x <- moderateRisk); 
	int highRiskTotalLoc = (0 | it + x | x <- highRisk);
	int veryHighRiskTotalLoc = (0 | it + x | x <- veryHighRisk);

	// calculating percentage of the risks
	real moderateRiskPercentage = toReal(moderateRiskTotalLoc)/totalProductionLoc * 100;
	real highRiskPercentage = toReal(highRiskTotalLoc)/totalProductionLoc * 100;
	real veryHighRiskPercentage = toReal(veryHighRiskTotalLoc)/totalProductionLoc * 100;
	
	return getRating(moderateRiskPercentage, highRiskPercentage, veryHighRiskPercentage);
}

private str getRating(real moderateRiskPercentage, real highRiskPercentage, real veryHighRiskPercentage) {
	str result = "";
		
	if(moderateRiskPercentage <= 25 && highRiskPercentage == 0 && veryHighRiskPercentage == 0) {
		result = "++";
	} else if(moderateRiskPercentage <= 30 && highRiskPercentage <= 5 && veryHighRiskPercentage == 0) {
		result = "+";
	} else if(moderateRiskPercentage <= 40 && highRiskPercentage <= 10 && veryHighRiskPercentage == 0) {
		result = "o";
	} else if(moderateRiskPercentage <= 50 && highRiskPercentage <= 15 && veryHighRiskPercentage <= 5) {
		result = "-";
	} else {
		result = "--";
	}
	
	return result;
}

