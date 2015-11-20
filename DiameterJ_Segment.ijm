//Define Crop size of all images to be analyzed and define which segmentation algorithms to use
	Dialog.create("Location of Cropping Field");

		Dialog.setInsets(0, 80, 0);
		Dialog.addMessage("Basic Image Information");
			image_width = 1280;
			image_height = 960;
				Dialog.addNumber("Image Width (Uncropped)", image_width, 0, 7, "Pixels");
				Dialog.addNumber("Image Height (Uncropped)", image_height, 0 , 7, "Pixels");
		
		Dialog.setInsets(25, 98, 0);
		Dialog.addMessage("Cropping Location");
			crop_items = newArray("Yes", "No");
			Dialog.addChoice("Do you want to crop your image?", crop_items, "Yes");
				Dialog.addNumber("Top Left - X coordinate", 0);
				Dialog.addNumber("Top Left - Y coordinate", 0);
				Dialog.addNumber("Bottom Right - X coordinate", 1280);
				Dialog.addNumber("Bottom Right - Y coordinate", 880);
		
		Dialog.setInsets(25, 58, 0);		
		Dialog.addMessage("Segmentation Algorithms to Use");
			Seg_labels = newArray("None", "Traditional", "Stat. Region Merged", "Mixed");
			Seg_defaults = newArray(false, false, true, true);		
				Dialog.addCheckboxGroup(2, 2, Seg_labels, Seg_defaults)
		
		Dialog.setInsets(25, 98, 0);
		Dialog.addMessage("Batch Processing");
			radio_items = newArray("Yes", "No");
			Dialog.addRadioButtonGroup("Do you want to analyze more than one image?", radio_items, 1, 2, "Yes")
		
		Dialog.show;
		
		crop_outcome = Dialog.getChoice();

			if (crop_outcome == "Yes"){
				iw = Dialog.getNumber();
				ih = Dialog.getNumber();
				crop_tlx = Dialog.getNumber();
				crop_tly = Dialog.getNumber();
				crop_brx = Dialog.getNumber();
				crop_bry = Dialog.getNumber();
			};
			
			if (crop_outcome == "No"){
				image_width1 = Dialog.getNumber();
				image_height1 = Dialog.getNumber();
				crop_tlx = 0;
				crop_tly = 0;
				crop_brx = image_width1;
				crop_bry = image_height1;
			};
		
		TLCB_None = Dialog.getCheckbox();
		TRCB_Trad = Dialog.getCheckbox();
		BLCB_SRM = Dialog.getCheckbox();
		BRCB_Mix = Dialog.getCheckbox();
		Batch_analysis = Dialog.getRadioButton();
		
// Checks to see if user is using ImageJ or FIJI and corrects the thresholding variable accordingly
		IJorFIJI = getVersion();
			
		if (startsWith(IJorFIJI, 1)){
			thresh_dots = "Auto Threshold...";
			};
		if (startsWith(IJorFIJI, 2)){
			thresh_dots = "Auto Threshold";
			};		


if(Batch_analysis == "Yes") {
// Asks for a directory where Tif files are stored that you wish to analyze
	dir1 = getDirectory("Choose Source Directory ");
		list = getFileList(dir1);
		setBatchMode(true);
			
	T1 = getTime();	
	
	for (i=0; i<list.length; i++) {
		showProgress(i+1, list.length);
		filename = dir1 + list[i];
		
	if (endsWith(filename, "tif") || endsWith(filename, "tiff") || endsWith(filename, "Tif") || endsWith(filename, "Tiff") || endsWith(filename, "TIF") || endsWith(filename, "TIFF") ||
		endsWith(filename, "jpg") || endsWith(filename, "JPG") || endsWith(filename, "jpeg") || endsWith(filename, "JPEG") || endsWith(filename, "Jpeg") || endsWith(filename, "Jpg") || 
		endsWith(filename, "gif") || endsWith(filename, "GIF") || endsWith(filename, "Gif") || endsWith(filename, "Giff") || endsWith(filename, "giff") || endsWith(filename, "GIFF") ||
		endsWith(filename, "bmp") || endsWith(filename, "BMP") || endsWith(filename, "Bmp") ||
		endsWith(filename, "png") || endsWith(filename, "PNG") || endsWith(filename, "Png")) {
			print("Analyzing image: ",list[i]);
			open(filename);

// Create an empty folder with nothing in it
	myDir1 = dir1+"Best Segmentation"+File.separator;

	File.makeDirectory(myDir1);
		if (!File.exists(myDir1))
			exit("Unable to create directory");

			
// Save SRM images that have been segmented into a folder called Segmented Images
	myDir = dir1+"Segmented Images"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");

// Save Statistical Region Merged Images into a Folder called SRM
	myDir2 = dir1+"Montage Images"+File.separator;

	File.makeDirectory(myDir2);
		if (!File.exists(myDir2))
			exit("Unable to create directory");			
			
		
// Sets Scale of picture to pixels 
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
	
// Creates custom file names for use later
		var name0=getTitle;
		name = newArray(name0, getTitle+"_SRM", getTitle+"_M1", getTitle+"_M2", getTitle+"_M3",
				getTitle+"_M4", getTitle+"_M5", getTitle+"_M6", getTitle+"_M7", getTitle+"_M8",
				getTitle+"_Mix Montage", getTitle+"_SRM100", getTitle+"_SRM50", getTitle+"_S1",
				getTitle+"_S2", getTitle+"_S3", getTitle+"_S4", getTitle+"_S5", getTitle+"_S6",
				getTitle+"_S7", getTitle+"_S8", getTitle+"_SRM Montage", "image22",	getTitle+"_T1",
				getTitle+"_T2", getTitle+"_T3", getTitle+"_T4", getTitle+"_T5", getTitle+"_T6",
				getTitle+"_T7", getTitle+"_T8", getTitle+"_Trad Montage", getTitle+"_Trad&SRM Montage",
				getTitle+"_Trad&Mix Montage", getTitle+"_Mix&SRM Montage", getTitle+"_Trad&Mix&SRM Montage");
			
	for (n = 0; n <36; n++) {
		name[n]= replace(name[n],".tiff","");
		name[n]= replace(name[n],".Tiff","");
		name[n]= replace(name[n],".TIFF","");
		name[n]= replace(name[n],".tif","");
		name[n]= replace(name[n],".Tif","");
		name[n]= replace(name[n],".TIF","");
		name[n]= replace(name[n],".giff","");
		name[n]= replace(name[n],".Giff","");
		name[n]= replace(name[n],".GIFF","");
		name[n]= replace(name[n],".gif","");
		name[n]= replace(name[n],".Gif","");
		name[n]= replace(name[n],".GIF","");
		name[n]= replace(name[n],".jpg","");
		name[n]= replace(name[n],".jpeg","");
		name[n]= replace(name[n],".Jpg","");
		name[n]= replace(name[n],".Jpeg","");
		name[n]= replace(name[n],".JPG","");
		name[n]= replace(name[n],".JPEG","");
		name[n]= replace(name[n],".bmp","");
		name[n]= replace(name[n],".Bmp","");
		name[n]= replace(name[n],".BMP","");
		name[n]= replace(name[n],".png","");
		name[n]= replace(name[n],".Png","");
		name[n]= replace(name[n],".PNG","");
	};

// Creates custom file paths for use later
		var path0 = myDir1+name[0];
		var path1 = myDir+name[2];
		var path3 = myDir+name[3];
		var path4 = myDir+name[4];
		var path5 = myDir+name[5];
		var path6 = myDir+name[6];
		var path7 = myDir+name[7];
		var path8 = myDir+name[8];
		var path9 = myDir+name[9];
		var path10 = myDir2+name[10];
		
		var path11 = myDir+name[11];
		var path12 = myDir+name[12];
		var path13 = myDir+name[13];
		var path14 = myDir+name[14];
		var path15 = myDir+name[15];
		var path16 = myDir+name[16];
		var path17 = myDir+name[17];
		var path18 = myDir+name[18];
		var path19 = myDir+name[19];
		var path20 = myDir+name[20];
		var path21 = myDir2+name[21];
		
		var path23 = myDir+name[23];
		var path24 = myDir+name[24];
		var path25 = myDir+name[25];
		var path26 = myDir+name[26];
		var path27 = myDir+name[27];
		var path28 = myDir+name[28];
		var path29 = myDir+name[29];
		var path30 = myDir+name[30];
		
		var path31 = myDir2+name[31];
		var path32 = myDir2+name[32];
		var path33 = myDir2+name[33];
		var path34 = myDir2+name[34];
		var path35 = myDir2+name[35];


// Runs all traditional segmentation algorithms		
	if (TRCB_Trad == 1 && TLCB_None == 0){
		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
				run("Crop");
// Runs a Runs Huang thresholding on the image
				run(thresh_dots, "method=Huang ignore_white white");

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
				run("Fill Holes");		
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
		saveAs("Tiff", path23);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");				

// Runs a Percentile thresholding on the mage
				run(thresh_dots, "method=Percentile ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path24);
		run("Close All");		

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");				

// Runs a Runs MinError(I) thresholding on the image
				run(thresh_dots, "method=MinError(I) ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path25);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs a Runs Triangle thresholding on the image
				run(thresh_dots, "method=Triangle ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path26);
		run("Close All");	

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs a Li thresholding without ignoring white pixels on the image
				run(thresh_dots, "method=Li ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path27);
		run("Close All");	

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs an Otsu thresholding on the image
				run(thresh_dots, "method=Otsu ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path28);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs an MaxEntropy thresholding on the image
				run(thresh_dots, "method=MaxEntropy ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path29);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs an RenyiEntropy thresholding on the image
				run(thresh_dots, "method=RenyiEntropy ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path30);
		run("Close All");
		
		};


// Runs Mixed Segmentation Algorithms
	if (BRCB_Mix == 1 && TLCB_None == 0){
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");			

// Runs a Runs Huang thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Huang ignore_white white");

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
		saveAs("Tiff", path1);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image then segments via MinError() method
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");
					run(thresh_dots, "method=MinError(I) ignore_white white");
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
		saveAs("Tiff", path3);
		run("Close");

		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image then segments via Percentile method
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");
					run(thresh_dots, "method=Percentile white");
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
		
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image then segments via Triangle method
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");
					run(thresh_dots, "method=Triangle white");
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

	
	open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via Huang's method and saves the result after processing.

					run(thresh_dots, "method=Huang ignore_white white");
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

		
		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via MinError's method and saves the result after processing.

					run(thresh_dots, "method=MinError(I) white");
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

		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via Percentile's method and saves the result after processing.

					run(thresh_dots, "method=Percentile white");
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
		
		
		
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via Triangle's method and saves the result after processing.

					run(thresh_dots, "method=Triangle white");
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
		
		setForegroundColor(0,0,0);
	run("Close All");
	}

// Runs Statistical Region Merging Segmentation Techniques on all of the images
	if(BLCB_SRM == 1 && TLCB_None == 0){
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
				run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image
			run("Statistical Region Merging", "q=100 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);

		open(path11+".tif");
			run("Statistical Region Merging", "q=50 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);
		open(path11+".tif");
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);
						run("Close");	
						
		open(path11+".tif");
			run("Statistical Region Merging", "q=12 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);
						run("Close All");							

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
	run("Statistical Region Merging", "q=50 showaverages");
					run("8-bit");	
							saveAs("Tiff", path12);
			open(path12+".tif");
				run("Statistical Region Merging", "q=10 showaverages");
					run("8-bit");	
							saveAs("Tiff", path12);
							run("Close");	
						

open(path11+".tif");
	// Runs a Runs Huang thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Huang ignore_white white");

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
		saveAs("Tiff", path13);
		run("Close");	

open(path11+".tif");
	// Runs a Min Error thresholding on the SRM 8-bit image
				run(thresh_dots, "method=MinError(I) ignore_white white");

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
		saveAs("Tiff", path14);
		run("Close");	

open(path11+".tif");
	// Runs a Percentile thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Percentile white");

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
		saveAs("Tiff", path15);
		run("Close");	

open(path11+".tif");
	// Runs a Triangle thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Triangle white");

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
		saveAs("Tiff", path16);
		run("Close");	

open(path12+".tif");
	// Runs a Runs Huang thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Huang ignore_white white");

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
		saveAs("Tiff", path17);
		run("Close");	

open(path12+".tif");
	// Runs a Min Error thresholding on the SRM 8-bit image
				run(thresh_dots, "method=MinError(I) ignore_white white");

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
		saveAs("Tiff", path18);
		run("Close");	

open(path12+".tif");
	// Runs a Percentile thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Percentile white");

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
		saveAs("Tiff", path19);
		run("Close");	

open(path12+".tif");
	// Runs a Triangle thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Triangle white");

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
		saveAs("Tiff", path20);

	run("Close All");
	File.delete(path11+".tif");
	File.delete(path12+".tif");
	setForegroundColor(0,0,0);
	print("\\Clear");
	
	}

if(TLCB_None == 1){
		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
			saveAs("Tiff", path0);
			print("\\Clear");
			run("Close All");
			};
	

// Create Montage Image if Mixed segmentation only was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 0 && BLCB_SRM == 0 && BRCB_Mix == 1) { 
		
		open(name0);
			run("Invert");
		open(path1+".tif");
		open(path3+".tif");
		open(path4+".tif");
		open(path5+".tif");
		open(path6+".tif");
		open(path7+".tif");
		open(path8+".tif");
		open(path9+".tif");

		run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
				run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
						run("Make Montage...", "columns=3 rows=3 scale=0.75 first=1 last=9 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path10);
			run("Close");
			run("Close");
				setForegroundColor(0,0,0);
	};
	
	
// Create Montage Image if SRM segmentation only was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 0 && BLCB_SRM == 1 && BRCB_Mix == 0) { 
		open(name0);
			run("Invert");
		open(path13+".tif");
		open(path14+".tif");
		open(path15+".tif");
		open(path16+".tif");
		open(path17+".tif");
		open(path18+".tif");
		open(path19+".tif");
		open(path20+".tif");

			run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
			run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
					run("Make Montage...", "columns=3 rows=3 scale=0.75 first=1 last=9 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path21);
		run("Close");
		run("Close");
			setForegroundColor(0,0,0);
	};
	


// Create a Montage image if only Traditional Segmentation was chosen		
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 0 && BRCB_Mix == 0) { 
			open(name0);
				run("Invert");
			open(path23+".tif");
			open(path24+".tif");
			open(path25+".tif");
			open(path26+".tif");
			open(path27+".tif");
			open(path28+".tif");
			open(path29+".tif");
			open(path30+".tif");

				run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
				selectWindow("Stack");
				run("Invert", "slice");
					run("RGB Color");
						setForegroundColor(175,0,0);
						run("Make Montage...", "columns=3 rows=3 scale=0.75 first=1 last=9 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path31);
		run("Close");
		run("Close");
		print("\\Clear");		
			setForegroundColor(0,0,0);
	};

// Create a Montage image if Traditional and SRM Segmentation was chosen		
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 1 && BRCB_Mix == 0) { 
			open(name0);
				run("Invert");
			open(path13+".tif");
			open(path14+".tif");
			open(path15+".tif");
			open(path17+".tif");
			open(path18+".tif");
			open(path19+".tif");
			open(path20+".tif");
			open(path23+".tif");
			open(path24+".tif");
			open(path25+".tif");
			open(path26+".tif");
			open(path27+".tif");
			open(path28+".tif");
			open(path29+".tif");
			open(path30+".tif");

				run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
				selectWindow("Stack");
				run("Invert", "slice");
					run("RGB Color");
						setForegroundColor(175,0,0);
						run("Make Montage...", "columns=4 rows=4 scale=0.75 first=1 last=16 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path32);
		run("Close");
		run("Close");		
			setForegroundColor(0,0,0);
	};		

// Create a Montage image if Traditional and Mixed Segmentation was chosen		
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 0 && BRCB_Mix == 1) { 
			open(name0);
				run("Invert");
			open(path1+".tif");
			open(path3+".tif");
			open(path4+".tif");
			open(path6+".tif");
			open(path7+".tif");
			open(path8+".tif");
			open(path9+".tif");
			open(path23+".tif");
			open(path24+".tif");
			open(path25+".tif");
			open(path26+".tif");
			open(path27+".tif");
			open(path28+".tif");
			open(path29+".tif");
			open(path30+".tif");

				run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
				selectWindow("Stack");
				run("Invert", "slice");
					run("RGB Color");
						setForegroundColor(175,0,0);
						run("Make Montage...", "columns=4 rows=4 scale=0.75 first=1 last=16 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path33);
		run("Close");
		run("Close");		
			setForegroundColor(0,0,0);
	};

// Create Montage Image if Both SRM and Mixed Segmentation was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 0 && BLCB_SRM == 1 && BRCB_Mix == 1) { 

		open(name0);
			run("Invert");
		open(path1+".tif");
		open(path3+".tif");
		open(path4+".tif");
		open(path5+".tif");
		open(path6+".tif");
		open(path7+".tif");
		open(path8+".tif");
		open(path9+".tif");
		open(path13+".tif");
		open(path14+".tif");
		open(path15+".tif");
		open(path17+".tif");
		open(path18+".tif");
		open(path19+".tif");
		open(path20+".tif");
	
	run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
			run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
					run("Make Montage...", "columns=4 rows=4 scale=0.75 first=1 last=16 increment=1 border=5 font=27 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path34);
		run("Close");
		run("Close");
			setForegroundColor(0,0,0);
	};	

// Create Montage Image if Traditional, SRM, and Mixed Segmentation was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 1 && BRCB_Mix == 1) { 

		open(name0);
			run("Invert");
		open(path1+".tif");
		open(path3+".tif");
		open(path4+".tif");
		open(path5+".tif");
		open(path6+".tif");
		open(path7+".tif");
		open(path8+".tif");
		open(path9+".tif");
		open(path13+".tif");
		open(path14+".tif");
		open(path15+".tif");
		open(path16+".tif");
		open(path17+".tif");
		open(path18+".tif");
		open(path19+".tif");
		open(path20+".tif");
		open(path23+".tif");
		open(path24+".tif");
		open(path25+".tif");
		open(path26+".tif");
		open(path27+".tif");
		open(path28+".tif");
		open(path29+".tif");
		open(path30+".tif");
	
	run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
			run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
					run("Make Montage...", "columns=5 rows=5 scale=0.75 first=1 last=25 increment=1 border=5 font=39 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path35);
		run("Close");
		run("Close");
			setForegroundColor(0,0,0);
	};		
	};
		};
	};

if(Batch_analysis == "No") {
// Asks for a directory where Tif files are stored that you wish to analyze
	dir1 = getDirectory("Choose Directory to Store Output Images In");
		setBatchMode(true);
			
	T1 = getTime();	
	
			print("Analyzing image: ", getTitle);

// Create an empty folder with nothing in it
	myDir1 = dir1+"Best Segmentation"+File.separator;

	File.makeDirectory(myDir1);
		if (!File.exists(myDir1))
			exit("Unable to create directory");

			
// Save SRM images that have been segmented into a folder called Segmented Images
	myDir = dir1+"Segmented Images"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");

// Save Statistical Region Merged Images into a Folder called SRM
	myDir2 = dir1+"Montage Images"+File.separator;

	File.makeDirectory(myDir2);
		if (!File.exists(myDir2))
			exit("Unable to create directory");			
			
		
// Sets Scale of picture to pixels 
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
	
// Creates custom file names for use later
		var name0=getTitle;
		name = newArray(name0, getTitle+"_SRM", getTitle+"_M1", getTitle+"_M2", getTitle+"_M3",
				getTitle+"_M4", getTitle+"_M5", getTitle+"_M6", getTitle+"_M7", getTitle+"_M8",
				getTitle+"_Mix Montage", getTitle+"_SRM100", getTitle+"_SRM50", getTitle+"_S1",
				getTitle+"_S2", getTitle+"_S3", getTitle+"_S4", getTitle+"_S5", getTitle+"_S6",
				getTitle+"_S7", getTitle+"_S8", getTitle+"_SRM Montage", "image22",	getTitle+"_T1",
				getTitle+"_T2", getTitle+"_T3", getTitle+"_T4", getTitle+"_T5", getTitle+"_T6",
				getTitle+"_T7", getTitle+"_T8", getTitle+"_Trad Montage", getTitle+"_Trad&SRM Montage",
				getTitle+"_Trad&Mix Montage", getTitle+"_Mix&SRM Montage", getTitle+"_Trad&Mix&SRM Montage");

	for (n = 0; n <36; n++) {
		name[n]= replace(name[n],".tiff","");
		name[n]= replace(name[n],".Tiff","");
		name[n]= replace(name[n],".TIFF","");
		name[n]= replace(name[n],".tif","");
		name[n]= replace(name[n],".Tif","");
		name[n]= replace(name[n],".TIF","");
		name[n]= replace(name[n],".giff","");
		name[n]= replace(name[n],".Giff","");
		name[n]= replace(name[n],".GIFF","");
		name[n]= replace(name[n],".gif","");
		name[n]= replace(name[n],".Gif","");
		name[n]= replace(name[n],".GIF","");
		name[n]= replace(name[n],".jpg","");
		name[n]= replace(name[n],".jpeg","");
		name[n]= replace(name[n],".Jpg","");
		name[n]= replace(name[n],".Jpeg","");
		name[n]= replace(name[n],".JPG","");
		name[n]= replace(name[n],".JPEG","");
		name[n]= replace(name[n],".bmp","");
		name[n]= replace(name[n],".Bmp","");
		name[n]= replace(name[n],".BMP","");
		name[n]= replace(name[n],".png","");
		name[n]= replace(name[n],".Png","");
		name[n]= replace(name[n],".PNG","");
	};

// Creates custom file paths for use later
		var path0 = myDir1+name[0];
		var path1 = myDir+name[2];
		var path3 = myDir+name[3];
		var path4 = myDir+name[4];
		var path5 = myDir+name[5];
		var path6 = myDir+name[6];
		var path7 = myDir+name[7];
		var path8 = myDir+name[8];
		var path9 = myDir+name[9];
		var path10 = myDir2+name[10];
		
		var path11 = myDir+name[11];
		var path12 = myDir+name[12];
		var path13 = myDir+name[13];
		var path14 = myDir+name[14];
		var path15 = myDir+name[15];
		var path16 = myDir+name[16];
		var path17 = myDir+name[17];
		var path18 = myDir+name[18];
		var path19 = myDir+name[19];
		var path20 = myDir+name[20];
		var path21 = myDir2+name[21];
		
		var path23 = myDir+name[23];
		var path24 = myDir+name[24];
		var path25 = myDir+name[25];
		var path26 = myDir+name[26];
		var path27 = myDir+name[27];
		var path28 = myDir+name[28];
		var path29 = myDir+name[29];
		var path30 = myDir+name[30];
		
		var path31 = myDir2+name[31];
		var path32 = myDir2+name[32];
		var path33 = myDir2+name[33];
		var path34 = myDir2+name[34];
		var path35 = myDir2+name[35];
		
		
// Runs all traditional segmentation algorithms		
	if (TRCB_Trad == 1 && TLCB_None == 0){
		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
				run("Crop");
// Runs a Runs Huang thresholding on the image
				run(thresh_dots, "method=Huang ignore_white white");

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
				run("Fill Holes");		
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
		saveAs("Tiff", path23);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");				

// Runs a Percentile thresholding on the mage
				run(thresh_dots, "method=Percentile ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path24);
		run("Close All");		

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");				

// Runs a Runs MinError(I) thresholding on the image
				run(thresh_dots, "method=MinError(I) ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path25);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs a Runs Triangle thresholding on the image
				run(thresh_dots, "method=Triangle ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path26);
		run("Close All");	

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs a Li thresholding without ignoring white pixels on the image
				run(thresh_dots, "method=Li ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path27);
		run("Close All");	

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs an Otsu thresholding on the image
				run(thresh_dots, "method=Otsu ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path28);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs an MaxEntropy thresholding on the image
				run(thresh_dots, "method=MaxEntropy ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path29);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");	

// Runs an RenyiEntropy thresholding on the image
				run(thresh_dots, "method=RenyiEntropy ignore_white white");

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
				run("Fill Holes");			
		
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
		saveAs("Tiff", path30);
		run("Close All");
		
		};


// Runs Mixed Segmentation Algorithms
	if (BRCB_Mix == 1 && TLCB_None == 0){
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");			

// Runs a Runs Huang thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Huang ignore_white white");

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
		saveAs("Tiff", path1);
		run("Close All");

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image then segments via MinError() method
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");
					run(thresh_dots, "method=MinError(I) ignore_white white");
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
		saveAs("Tiff", path3);
		run("Close");

		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image then segments via Percentile method
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");
					run(thresh_dots, "method=Percentile white");
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
		
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image then segments via Triangle method
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");
					run(thresh_dots, "method=Triangle white");
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

	
	open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via Huang's method and saves the result after processing.

					run(thresh_dots, "method=Huang ignore_white white");
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

		
		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via MinError's method and saves the result after processing.

					run(thresh_dots, "method=MinError(I) white");
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

		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via Percentile's method and saves the result after processing.

					run(thresh_dots, "method=Percentile white");
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
		
		
		
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
// Runs a segmentation via Triangle's method and saves the result after processing.

					run(thresh_dots, "method=Triangle white");
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
		
		setForegroundColor(0,0,0);
	run("Close All");
	}

// Runs Statistical Region Merging Segmentation Techniques on all of the images
	if(BLCB_SRM == 1 && TLCB_None == 0){
		open(name0);
		run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
				run("Crop");
// Runs a Statistical Region Merging (SRM) Segmentation technique with 25 grey scale values and converts picture to an 8-bit image
			run("Statistical Region Merging", "q=100 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);

		open(path11+".tif");
			run("Statistical Region Merging", "q=50 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);
		open(path11+".tif");
			run("Statistical Region Merging", "q=25 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);
						run("Close");	
						
		open(path11+".tif");
			run("Statistical Region Merging", "q=12 showaverages");
				run("8-bit");	
						saveAs("Tiff", path11);
						run("Close All");							

open(name0);
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
		makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
	run("Statistical Region Merging", "q=50 showaverages");
					run("8-bit");	
							saveAs("Tiff", path12);
			open(path12+".tif");
				run("Statistical Region Merging", "q=10 showaverages");
					run("8-bit");	
							saveAs("Tiff", path12);
							run("Close");	
						

open(path11+".tif");
	// Runs a Runs Huang thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Huang ignore_white white");

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
		saveAs("Tiff", path13);
		run("Close");	

open(path11+".tif");
	// Runs a Min Error thresholding on the SRM 8-bit image
				run(thresh_dots, "method=MinError(I) ignore_white white");

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
		saveAs("Tiff", path14);
		run("Close");	

open(path11+".tif");
	// Runs a Percentile thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Percentile white");

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
		saveAs("Tiff", path15);
		run("Close");	

open(path11+".tif");
	// Runs a Triangle thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Triangle white");

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
		saveAs("Tiff", path16);
		run("Close");	

open(path12+".tif");
	// Runs a Runs Huang thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Huang ignore_white white");

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
		saveAs("Tiff", path17);
		run("Close");	

open(path12+".tif");
	// Runs a Min Error thresholding on the SRM 8-bit image
				run(thresh_dots, "method=MinError(I) ignore_white white");

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
		saveAs("Tiff", path18);
		run("Close");	

open(path12+".tif");
	// Runs a Percentile thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Percentile white");

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
		saveAs("Tiff", path19);
		run("Close");	

open(path12+".tif");
	// Runs a Triangle thresholding on the SRM 8-bit image
				run(thresh_dots, "method=Triangle white");

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
		saveAs("Tiff", path20);

	run("Close All");
	File.delete(path11+".tif");
	File.delete(path12+".tif");
	setForegroundColor(0,0,0);
	print("\\Clear");
	
}

if(TLCB_None == 1){
		open(name0);
			run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
			makeRectangle(crop_tlx, crop_tly, crop_brx, crop_bry);
			run("Crop");
			saveAs("Tiff", path0);
			print("\\Clear");
			run("Close All");
			};
	

// Create Montage Image if Mixed segmentation only was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 0 && BLCB_SRM == 0 && BRCB_Mix == 1) { 
		
		open(name0);
			run("Invert");
		open(path1+".tif");
		open(path3+".tif");
		open(path4+".tif");
		open(path5+".tif");
		open(path6+".tif");
		open(path7+".tif");
		open(path8+".tif");
		open(path9+".tif");

		run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
				run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
						run("Make Montage...", "columns=3 rows=3 scale=0.75 first=1 last=9 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path10);
			run("Close");
			run("Close");
				setForegroundColor(0,0,0);
	};
	
	
// Create Montage Image if SRM segmentation only was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 0 && BLCB_SRM == 1 && BRCB_Mix == 0) { 
		open(name0);
			run("Invert");
		open(path13+".tif");
		open(path14+".tif");
		open(path15+".tif");
		open(path16+".tif");
		open(path17+".tif");
		open(path18+".tif");
		open(path19+".tif");
		open(path20+".tif");

			run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
			run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
					run("Make Montage...", "columns=3 rows=3 scale=0.75 first=1 last=9 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path21);
		run("Close");
		run("Close");
			setForegroundColor(0,0,0);
	};
	


// Create a Montage image if only Traditional Segmentation was chosen		
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 0 && BRCB_Mix == 0) { 
			open(name0);
				run("Invert");
			open(path23+".tif");
			open(path24+".tif");
			open(path25+".tif");
			open(path26+".tif");
			open(path27+".tif");
			open(path28+".tif");
			open(path29+".tif");
			open(path30+".tif");

				run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
				selectWindow("Stack");
				run("Invert", "slice");
					run("RGB Color");
						setForegroundColor(175,0,0);
						run("Make Montage...", "columns=3 rows=3 scale=0.75 first=1 last=9 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path31);
		run("Close");
		run("Close");	
		print("\\Clear");
			setForegroundColor(0,0,0);
	};

// Create a Montage image if Traditional and SRM Segmentation was chosen		
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 1 && BRCB_Mix == 0) { 
			open(name0);
				run("Invert");
			open(path13+".tif");
			open(path14+".tif");
			open(path15+".tif");
			open(path17+".tif");
			open(path18+".tif");
			open(path19+".tif");
			open(path20+".tif");
			open(path23+".tif");
			open(path24+".tif");
			open(path25+".tif");
			open(path26+".tif");
			open(path27+".tif");
			open(path28+".tif");
			open(path29+".tif");
			open(path30+".tif");

				run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
				selectWindow("Stack");
				run("Invert", "slice");
					run("RGB Color");
						setForegroundColor(175,0,0);
						run("Make Montage...", "columns=4 rows=4 scale=0.75 first=1 last=16 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path32);
		run("Close");
		run("Close");		
			setForegroundColor(0,0,0);
	};		

// Create a Montage image if Traditional and Mixed Segmentation was chosen		
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 0 && BRCB_Mix == 1) { 
			open(name0);
				run("Invert");
			open(path1+".tif");
			open(path3+".tif");
			open(path4+".tif");
			open(path6+".tif");
			open(path7+".tif");
			open(path8+".tif");
			open(path9+".tif");
			open(path23+".tif");
			open(path24+".tif");
			open(path25+".tif");
			open(path26+".tif");
			open(path27+".tif");
			open(path28+".tif");
			open(path29+".tif");
			open(path30+".tif");

				run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
				selectWindow("Stack");
				run("Invert", "slice");
					run("RGB Color");
						setForegroundColor(175,0,0);
						run("Make Montage...", "columns=4 rows=4 scale=0.75 first=1 last=16 increment=1 border=5 font=18 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path33);
		run("Close");
		run("Close");		
			setForegroundColor(0,0,0);
	};

// Create Montage Image if Both SRM and Mixed Segmentation was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 0 && BLCB_SRM == 1 && BRCB_Mix == 1) { 

		open(name0);
			run("Invert");
		open(path1+".tif");
		open(path3+".tif");
		open(path4+".tif");
		open(path5+".tif");
		open(path6+".tif");
		open(path7+".tif");
		open(path8+".tif");
		open(path9+".tif");
		open(path13+".tif");
		open(path14+".tif");
		open(path15+".tif");
		open(path17+".tif");
		open(path18+".tif");
		open(path19+".tif");
		open(path20+".tif");
	
	run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
			run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
					run("Make Montage...", "columns=4 rows=4 scale=0.75 first=1 last=16 increment=1 border=5 font=27 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path34);
		run("Close");
		run("Close");
			setForegroundColor(0,0,0);
	};	

// Create Montage Image if Traditional, SRM, and Mixed Segmentation was chosen
	if(	TLCB_None == 0 && TRCB_Trad == 1 && BLCB_SRM == 1 && BRCB_Mix == 1) { 

		open(name0);
			run("Invert");
		open(path1+".tif");
		open(path3+".tif");
		open(path4+".tif");
		open(path5+".tif");
		open(path6+".tif");
		open(path7+".tif");
		open(path8+".tif");
		open(path9+".tif");
		open(path13+".tif");
		open(path14+".tif");
		open(path15+".tif");
		open(path16+".tif");
		open(path17+".tif");
		open(path18+".tif");
		open(path19+".tif");
		open(path20+".tif");
		open(path23+".tif");
		open(path24+".tif");
		open(path25+".tif");
		open(path26+".tif");
		open(path27+".tif");
		open(path28+".tif");
		open(path29+".tif");
		open(path30+".tif");
	
	run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");
			run("Invert", "slice");
				run("RGB Color");
					setForegroundColor(175,0,0);
					run("Make Montage...", "columns=5 rows=5 scale=0.75 first=1 last=25 increment=1 border=5 font=39 label use");

// Saves B&W picture for analysis
		saveAs("PNG", path35);
		run("Close");
		run("Close");
			setForegroundColor(0,0,0);
	};		
	};

T2 = getTime();
TTime = (T2-T1)/1000;
	if(TLCB_None == 1){
		print("You've chosen to crop all your images and not segment them \n All Images Cropped Successfully in:",TTime," Seconds");
				};
	if(TLCB_None != 1){
		print("All Images Segmented Successfully in:",TTime," Seconds");
	};





