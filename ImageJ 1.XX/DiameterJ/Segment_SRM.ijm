// Asks for a directory where Tif files are stored that you wish to analyze
	dir1 = getDirectory("Choose Source Directory ");
		list = getFileList(dir1);
		setBatchMode(true);
	


//Define Crop size of all images to be analyzed
	Crop_bin= getNumber("Do you want to crop the image? (1 = Yes    2 = No)",1);
	if (Crop_bin==1){
		cropw= getNumber("Croped image width (pixels)",1280);
		croph= getNumber("Croped image height (pixels)",880);};
		

	T1 = getTime();	
	
	for (i=0; i<list.length; i++) {
		showProgress(i+1, list.length);
		filename = dir1 + list[i];
	if (endsWith(filename, "tif")) {
		open(filename);

			
// Save SRM images that have been segmented into a folder called SRM Seg
	myDir = dir1+"SRM_Seg"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");

// Save SRM images that have been segmented into a folder called SRM Montage
	myDir1 = dir1+"SRM_Montage"+File.separator;

	File.makeDirectory(myDir1);
		if (!File.exists(myDir1))
			exit("Unable to create directory");

			
// Sets Scale of picture to pixels 
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
	
// Creates custom file names for use later
		var name0=getTitle;
		var name1=getTitle+"_SRM_100d2";
		var name2=getTitle+"_SRM_50_10";
		var name3=getTitle+"_SRM_100d2_H";
		var name4=getTitle+"_SRM_100d2_M";
		var name5=getTitle+"_SRM_100d2_P";
		var name6=getTitle+"_SRM_100d2_T";
		var name7=getTitle+"_SRM_SRM_50_10_H";
		var name8=getTitle+"_SRM_50_10_M";
		var name9=getTitle+"_SRM_50_10_P";
		var name10=getTitle+"_SRM_50_10_T";
		var name11=getTitle+"_Montage";

// Creates custom file paths for use later
		var path0 = myDir+name0;
		var path1 = myDir+name1;
		var path2 = myDir+name2;
		var path3 = myDir+name3;
		var path4 = myDir+name4;
		var path5 = myDir+name5;
		var path6 = myDir+name6;
		var path7 = myDir+name7;
		var path8 = myDir+name8;
		var path9 = myDir+name9;
		var path10 = myDir+name10;
		var path11 = myDir1+name11;


// Creates a rectangle the entire size of the picture if no image crop is desired
	if (Crop_bin==2){
		cropw= getWidth();
		croph= getHeight();};
		totalarea= cropw*croph;
		
// Crops picture to cropw x croph dimensions in pixels	
		makeRectangle(0, 0, cropw, croph);
			run("Crop");

// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image
			run("Statistical Region Merging", "q=100 showaverages");
				run("8-bit");	
						saveAs("Tiff", path1);
		open(path1+".tif");
			run("Statistical Region Merging", "q=50 showaverages");
				run("8-bit");	
						saveAs("Tiff", path1);
		open(path1+".tif");
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");	
						saveAs("Tiff", path1);
						run("Close");	
						
		open(path1+".tif");
			run("Statistical Region Merging", "q=12 showaverages");
				run("8-bit");	
						saveAs("Tiff", path1);
						run("Close");							

open(name0);
		makeRectangle(0, 0, cropw, croph);
			run("Crop");
	run("Statistical Region Merging", "q=50 showaverages");
					run("8-bit");	
							saveAs("Tiff", path2);
			open(path2+".tif");
				run("Statistical Region Merging", "q=10 showaverages");
					run("8-bit");	
							saveAs("Tiff", path2);
							run("Close");	
						

open(path1+".tif");
	// Runs a Runs Huang thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=Huang ignore_white white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path3);
		run("Close");	

open(path1+".tif");
	// Runs a Min Error thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=MinError(I) ignore_white white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
					run("Fill Holes");
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path4);
		run("Close");	

open(path1+".tif");
	// Runs a Percentile thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=Percentile white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
					run("Fill Holes");
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path5);
		run("Close");	

open(path1+".tif");
	// Runs a Triangle thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=Triangle white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
					run("Fill Holes");
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path6);
		run("Close");	

open(path2+".tif");
	// Runs a Runs Huang thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=Huang ignore_white white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
					run("Fill Holes");
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path7);
		run("Close");	

open(path2+".tif");
	// Runs a Min Error thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=MinError(I) ignore_white white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
					run("Fill Holes");
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path8);
		run("Close");	

open(path2+".tif");
	// Runs a Percentile thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=Percentile white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
					run("Fill Holes");
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path9);
		run("Close");	

open(path2+".tif");
	// Runs a Triangle thresholding on the SRM 8-bit image
				run("Auto Threshold...", "method=Triangle white");

//Cleans up noise in image by filling in dark regions, despeckling in a loop until no noise (5px or less) groups remain, removes outliers and diates/erodes surfaces to remove surface morphological features.
					run("Fill Holes");
							getHistogram(values, counts, 256);
								Black_Pixels = counts[255];
									e= Black_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
		run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=3 threshold=50 which=Bright");
			run("Erode");
			run("Dilate");
		
		 black1=0;
		 black2=0;
		 getHistogram(values, counts, 256);
			black1= counts[255];
				run("Make Binary");
		getHistogram(values, counts, 256);
			black2= counts[255];
		if(black1 == black2 ){
			run("Invert");};

// Saves B&W picture for analysis
		saveAs("Tiff", path10);
		run("Close");


		
		
					run("Close All");
	
	open(name0);
	open(path3+".tif");
	open(path4+".tif");
	open(path5+".tif");
	open(path6+".tif");
	open(path7+".tif");
	open(path8+".tif");
	open(path9+".tif");
	open(path10+".tif");

		run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
		selectWindow("Stack");
		run("Invert", "stack");
		run("Invert", "slice");
			run("RGB Color");
				setForegroundColor(175,0,0);
				run("Make Montage...", "columns=3 rows=3 scale=0.35 first=1 last=9 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("Tiff", path11);
		run("Close");
		run("Close");
setForegroundColor(0,0,0);		

File.delete(path1+".tif");
File.delete(path2+".tif");
print("\\Clear");						

		} if (endsWith(filename, "tif")) {
		if (i == 1) {print(i+1," Images Analyzed Successfully");};
			if (i > 1) {print(i+1," Images Analyzed Successfully");};}
		
	} 
T2 = getTime();
TTime = (T2-T1)/1000;

print("All Images Segmented Successfully in:",TTime," Seconds");






