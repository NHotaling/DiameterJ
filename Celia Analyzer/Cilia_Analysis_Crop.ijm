// Asks for a directory where Tif files are stored that you wish to analyze
	dir1 = getDirectory("Choose Source Directory ");
		list = getFileList(dir1);
		setBatchMode(true);

//Creates a list of all tif files in the chosen directory that this program will analyze and opens the first one		
	for (i=0; i<list.length; i++) {
		showProgress(i+1, list.length);
		filename = dir1 + list[i];
	if (endsWith(filename, "tif")) {
		open(filename);

// Save All output files into a a subdirectory, called Results, of the location chosen above
	myDir = dir1+"Results"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");
		print(myDir);
		
// Sets Scale of picture to pixels 
	run("Set Scale...", "distance=0  known=0 pixel=1 unit= pixels");
	
// Creates custom file names for use later
		var name0=getTitle;
		var name1=getTitle+"_Green Histogram.csv";
		var name2=getTitle+"_Red Histogram.csv";
		var name3=getTitle+"_Yellow Histogram.csv";
		var name4=getTitle+"_Results.csv";

// Creates custom file paths for use later
		var path0 = myDir+name0;
		var path1 = myDir+name1;
		var path2 = myDir+name2;
		var path3 = myDir+name3;
		var path4 = myDir+name4;
	
// Sets the default measurements, scale, and crops the picture
		run("Set Measurements...", "area mean standard modal redirect=None decimal=6");
		run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
			makeRectangle(0, 165, 1390, 1041);
					run("Crop");

//Splits Picture into RGB Channels					
			run("Split Channels");

// Analyses the Green Channel
				selectWindow(name0+" (green)");
		
//Finds only the bright pixels, selects them and creates a new image with just those selected pixels on a black background
					run("adaptiveThr ", "using=[Weighted mean] from=9 then=-6 output");
						selectWindow("Mask");
						
//Removes all the noisy pixels that were accidentally selected with the above method				
							getHistogram(values, counts, 256);
								Green_Pixels = counts[255];
									c= Green_Pixels; 
										do {
											d=c;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area= counts[255];
												c = white_area;
											} while(c != d);	
											
//Selects all the pixels that have not been removed by the noise removal process and adds their location to a manager									
									run("Create Selection");
									run("Add to Manager");
							close;
					
//Selects the original green window and overlays the selected pixel locations from above				
					selectWindow(name0+" (green)");
						roiManager("Select", 0);
						
//Measures the intensity of all the selected pixels and takes the mean, mode, SD, and total number of pixels						
						run("Measure");
							Green_Mean = getResult("Mean",0);
							Green_SD = getResult("StdDev",0);
							Green_Mode = getResult("Mode",0);
							Green_Area = getResult("Area",0);
								run("Clear Results");

//Creates a histogram of all the selected pixel values								
						getHistogram(values, counts, 256);
								for (row=0; row<256; row++) {		
									setResult("Green Intensity", row, row);
									setResult("Green Count", row, counts[row]);
								} 
					
// Saves Histogram results table for Green pixels and clears all results
		saveAs("Results", path1);
	
		selectWindow("Results");
			run("Clear Results");
			run("Close");

			
// Red Channel Analysis is identical to green except we select the red window so no commenting in this section			
				selectWindow(name0+" (red)");
					run("adaptiveThr ", "using=[Weighted mean] from=9 then=-6 output");
						selectWindow("Mask");
							getHistogram(values, counts, 256);
								Red_Pixels = counts[255];
									e= Red_Pixels; 
										do {
											f=e;
												run("Despeckle");
												getHistogram(values, counts, 256);
													white_area1= counts[255];
												e = white_area1;
											} while(e != f);	
											
										
									run("Create Selection");
									run("Add to Manager");
							close;
					
					selectWindow(name0+" (red)");
						roiManager("Select", 1);
						
						run("Measure");
							Red_Mean = getResult("Mean",0);
							Red_SD = getResult("StdDev",0);
							Red_Mode = getResult("Mode",0);
							Red_Area = getResult("Area",0);
								run("Clear Results");

								
						getHistogram(values, counts, 256);
								for (row=0; row<256; row++) {		
									setResult("Red Intensity", row, row);
									setResult("Red Count", row, counts[row]);
								} 
					
// Saves Histogram Table for Red
		saveAs("Results", path2);
	
		selectWindow("Results");
			run("Clear Results");
			run("Close");

// Creates a selection where red and green overlap and adds that selection to the manager			
	roiManager("Select", newArray(0,1));
		roiManager("AND");	
			roiManager("Add");		

//Opens the original picture, sets measurements, and crops the picture	
	open(name0);
		run("Set Measurements...", "area mean standard modal redirect=None decimal=6");
			run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
				makeRectangle(0, 165, 1390, 1041);
						run("Crop");

//Overlays the overlapping red and green selection created above onto the original picture 						
				roiManager("Select", 2);

//Measures the intensity of all the selected pixels and takes the mean, mode, SD, and total number of pixels						
						run("Measure");
							Yellow_Mean = getResult("Mean",0);
							Yellow_SD = getResult("StdDev",0);
							Yellow_Mode = getResult("Mode",0);
							Yellow_Area = getResult("Area",0);
								run("Clear Results");

//Creates a histogram of all the selected pixel values								
						getHistogram(values, counts, 256);
								for (row=0; row<256; row++) {		
									setResult("Yellow Intensity", row, row);
									setResult("Yellow Count", row, counts[row]);
								} 
					
// Saves Histogram results table for Yellow pixels and clears all results
		saveAs("Results", path3);
	
		selectWindow("Results");
			run("Clear Results");
			run("Close");

//Closes all open pictures			
	run("Close All");

//Creates an array for all the area and intensity values determined above	
	Var = newArray("Green Area","Green Mean Intensity", "Green St.Dev", "Green Mode", "Red Area","Red Mean Intensity", "Red St.Dev", "Red Mode","Yellow Area","Yellow Mean Intensity", "Yellow St.Dev", "Yellow Mode");
							
			Value_Pixels = newArray(Green_Area,Green_Mean,Green_SD,Green_Mode,Red_Area,Red_Mean,Red_SD,Red_Mode,Yellow_Area,Yellow_Mean,Yellow_SD,Yellow_Mode);
	
	Array.show("Total Summary",Var,Value_Pixels);
		
		selectWindow("Total Summary");
			saveAs("Results",path4);
				run("Close");

						roiManager("reset");
						selectWindow("ROI Manager");
							run("Close");				
				run("Close All");
		}
	} print("All Images Analysed Successfully");





