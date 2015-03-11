// Asks for a directory where Tif files are stored that you wish to analyze
	dir1 = getDirectory("Choose Source Directory ");
		list = getFileList(dir1);
		setBatchMode(true);

	for (i=0; i<list.length; i++) {
		showProgress(i+1, list.length);
		filename = dir1 + list[i];
	if (endsWith(filename, "tif")) {
		open(filename);

// Save Converted B&W image into a new folder called Processed
		myDir = dir1+"Processed"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");
		print(myDir);
		
myDir1 = dir1+"Bin_Images"+File.separator;		
	File.makeDirectory(myDir1);
		if (!File.exists(myDir1))
			exit("Unable to create directory");
			print("");
		print(myDir1);

// Creates custom file names for use later
	var name0=getTitle+"_Analyzed";
	var name1=getTitle+"_Outlines";
	var name2=getTitle+"_Raw Data";
	var name3=getTitle+"_Summary";

// Creates custom file paths for use later
	var path0 = myDir1+name0;
	var path1 = myDir+name1;
	var path2 = myDir+name2; 
	var path3 = myDir+name3;

// Analyzes how dark or light a picture is
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
	run("Set Measurements...", "  mean integrated redirect=None decimal=6");
	run("Measure");
		shade = getResult("Mean");

// Creates an If/Then statement for different analyses based on how dark an image is
	if(shade > 95 && shade <= 135) {

// Create Black and white image for Particle analysis

		//run("Brightness/Contrast...");
			setMinAndMax(60, 185);
				run("Apply LUT");
			setAutoThreshold("Default dark");
		//run("Threshold...");
			setThreshold(35, 255);
				setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Convert to Mask");
			run("Fill Holes");
			run("Despeckle");
			run("Despeckle");
			run("Despeckle");
			run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
			run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Make Binary");

// Saves B&W picture for analysis
		saveAs("Tiff", path0);

// Analyzes dark areas from B&W picture
		run("Set Measurements...", "area standard fit shape skewness kurtosis redirect=None decimal=6");
		run("Analyze Particles...", "size=25-Infinity pixel circularity=0.00-1.00 show=Outlines display exclude clear include summarize");

// Saves and closes all of the generated windows
		saveAs("Tiff", path1);
		selectWindow("Results");
			saveAs("Results", path2+".csv");
		selectWindow("Results");
			run("Close");

		selectWindow("Summary");
			saveAs("Results", path3+".xls");
		selectWindow("Summary");
			run("Close");
		run("Close");
		}
	
	else
		if (shade >135) {
		//run("Brightness/Contrast...");
			setMinAndMax(100, 200);
				run("Apply LUT");
			setAutoThreshold("Default dark");
		//run("Threshold...");
				setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Convert to Mask");
			run("Fill Holes");
			run("Despeckle");
			run("Despeckle");
			run("Despeckle");
			run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
			run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Make Binary");

// Saves B&W picture for analysis
			saveAs("Tiff", path0);

// Analyzes dark areas from B&W picture
			run("Set Measurements...", "area standard fit shape skewness kurtosis redirect=None decimal=6");
		
			run("Analyze Particles...", "size=25-Infinity pixel circularity=0.00-1.00 show=Outlines display exclude clear include summarize");

// Saves and closes all of the generated windows
		saveAs("Tiff", path1);
		selectWindow("Results");
			saveAs("Results", path2+".csv");
		selectWindow("Results");
			run("Close");

		selectWindow("Summary");
			saveAs("Results", path3+".xls");
		selectWindow("Summary");
			run("Close");
		run("Close");
		}
		if (shade > 80 && shade<= 95) {
			//run("Brightness/Contrast...");
			setMinAndMax(50, 145);
				run("Apply LUT");
			setAutoThreshold("Default dark");
		//run("Threshold...");
			setThreshold(0, 25);
				setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Convert to Mask");
			run("Fill Holes");
			run("Despeckle");
			run("Despeckle");
			run("Despeckle");
			run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
			run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Make Binary");
			
// Saves B&W picture for analysis
		saveAs("Tiff", path0);

// Analyzes dark areas from B&W picture
		run("Set Measurements...", "area standard fit shape skewness kurtosis redirect=None decimal=6");
		run("Analyze Particles...", "size=50-Infinity pixel circularity=0.00-1.00 show=Outlines display exclude clear include summarize");

// Saves and closes all of the generated windows
		saveAs("Tiff", path1);
			selectWindow("Results");
		saveAs("Results", path2+".csv");
		selectWindow("Results");
			run("Close");
	
		selectWindow("Summary");
			saveAs("Results", path3+".xls");
		selectWindow("Summary");
			run("Close");
		run("Close");
		}
		else	
			if (shade <= 80) {
				//run("Brightness/Contrast...");
				setMinAndMax(50, 145);
					run("Apply LUT");
				setAutoThreshold("Default dark");
			//run("Threshold...");
				setThreshold(0, 25);
					setOption("BlackBackground", false);
			run("Convert to Mask");
				run("Fill Holes");
				run("Despeckle");
				run("Despeckle");
				run("Despeckle");
				run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
				run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
				run("Make Binary");
				run("Invert");
				
// Saves B&W picture for analysis
		saveAs("Tiff", path0);

// Analyzes dark areas from B&W picture
		run("Set Measurements...", "area standard fit shape skewness kurtosis redirect=None decimal=6");
		run("Analyze Particles...", "size=50-Infinity pixel circularity=0.00-1.00 show=Outlines display exclude clear include summarize");

// Saves and closes all of the generated windows
		saveAs("Tiff", path1);
			selectWindow("Results");
		saveAs("Results", path2+".csv");
		selectWindow("Results");
			run("Close");
	
		selectWindow("Summary");
			saveAs("Results", path3+".xls");
		selectWindow("Summary");
			run("Close");
		run("Close");
			close();
			}
		}
	}





