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
	myDir = dir1+"Processed Binary Images"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");
		print(myDir);
		
// Sets Scale of picture to pixels 
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
	
// Creates custom file names for use later
		var name0=getTitle;
		var name1=getTitle+"_Analyzed";

// Creates custom file paths for use later
		var path0 = myDir+name0;
		var path1 = myDir+name1;
	
// Analyzes how dark or light a picture is
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
		saveAs("Tiff", path1);
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
			saveAs("Tiff", path1);
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
		saveAs("Tiff", path1);
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
		saveAs("Tiff", path1);
		run("Close");
			}
		}
	}





