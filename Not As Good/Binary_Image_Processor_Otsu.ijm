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
		var name1=getTitle+"_BW";

// Creates custom file paths for use later
		var path0 = myDir+name0;
		var path1 = myDir+name1;
	
// Analyzes how dark or light a picture is
		run("Set Measurements...", "  mean integrated redirect=None decimal=6");
		run("Measure");
		shade = getResult("Mean");
				run("Clear Results");
			selectWindow("Results");
				run("Close");
		print(shade);
		
		
			if (shade <= 110) {
// These pictures are bright enough that the Otsu method does not invert them background/foreground so no invert after Otsu transformation is necessary
				run("Threshold", "method=Otsu stddev_multiplier=3 ignore_black white");
					run("Invert");
				run("Fill Holes");
				getHistogram(values, counts, 256);
					white_area= counts[0];
					black_area= counts[255];
					
				c= white_area; 
					do {
						d=c;
							run("Despeckle");
							getHistogram(values, counts, 256);
								white_area1= counts[0];
								black_area1= counts[255];
							c = white_area1;
						} while(c != d);					
					run("Erode");
					run("Dilate");
						run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
						run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Make Binary");	

// Saves B&W picture for analysis
		saveAs("Tiff", path1);
		run("Close");
		}
			if (shade > 110 && shade <= 130) {
// These pictures are bright enough that the Otsu method does not invert them background/foreground so no invert after Otsu transformation is necessary
				run("Threshold", "method=Otsu stddev_multiplier=3 ignore_black white");
					run("Invert");
					
					getHistogram(values, counts, 256);
					white_area= counts[0];
					black_area= counts[255];
					
				c= white_area; 
					do {
						d=c;
							run("Despeckle");
							getHistogram(values, counts, 256);
								white_area1= counts[0];
								black_area1= counts[255];
							c = white_area1;
						} while(c != d);					
					run("Erode");
					run("Dilate");
						run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
						run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Make Binary");	

// Saves B&W picture for analysis
		saveAs("Tiff", path1);
		run("Close");
		}


			if (shade > 130) {
// These pictures are bright enough that the Otsu method does not invert them background/foreground so no invert after Otsu transformation is necessary
				run("Threshold", "method=Otsu stddev_multiplier=3 ignore_black white");
					run("Fill Holes");
			
			getHistogram(values, counts, 256);
					white_area= counts[0];
					black_area= counts[255];
					
				c= white_area; 
					do {
						d=c;
							run("Despeckle");
							getHistogram(values, counts, 256);
								white_area1= counts[0];
								black_area1= counts[255];
							c = white_area1;
						} while(c != d);					
					run("Erode");
					run("Dilate");
						run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
						run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Make Binary");

		
// Saves B&W picture for analysis
		saveAs("Tiff", path1);
		run("Close");
			}
		}
	}





