// Asks for a directory where Tif files are stored that you wish to analyze
	dir1 = getDirectory("Choose Source Directory ");
		list = getFileList(dir1);
		setBatchMode(true);

	T1 = getTime();
	
	for (i=0; i<list.length; i++) {
		showProgress(i+1, list.length);
		filename = dir1 + list[i];
	if (endsWith(filename, "tif")) {
		open(filename);

// Save Analyzed B&W image into a new folder called Diameter Analysis
	myDir = dir1+"Diameter Analysis Images"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");

// Save Overall Summary of Diameters into a new folder called Summaries
	myDir1 = dir1+"Summaries"+File.separator;

	File.makeDirectory(myDir1);
		if (!File.exists(myDir1))
			exit("Unable to create directory");
	
// Save Overall Summary of Diameters into a new folder called Histograms
	myDir2 = dir1+"Histograms"+File.separator;

	File.makeDirectory(myDir2);
		if (!File.exists(myDir2))
			exit("Unable to create directory");			
				
// Creates custom file names for use later
			var name0= getTitle;
			var name1= getTitle+"_Voronoi";	
			var name2= getTitle+"_Axial Thinning.tif";
			var name3= getTitle+"_Diameter";
			var name4= getTitle+"_log";
			var name5= getTitle+"_Total Summary.csv";
			var name6= getTitle+"_Radius Histogram";
			var name8= getTitle+"_Histogram.csv";
			var name9= replace(name0, ".tif", "-1.tif");
			var name10= getTitle+"_Pore Outlines";
			var name11= getTitle+"_Pore Data";
			var name12= getTitle+"_Pore Summary";
			var name13= getTitle+"_Intersection Coordinates.txt";
			var name14= getTitle+"_Dilate";
			var name15= getTitle+"_Dilated Diam";
			var name17= getTitle+"_Orientation";
			
// Creates custom file paths for use later
			var path0 = myDir+name0;
			var path1 = myDir+name1;			
			var path2 = myDir+name2;
			var path3 = myDir+name3;
			var path4 = myDir+name4;
			var path5 = myDir1+name5;
			var path6 = myDir2+name6;
			var path8 = myDir2+name8;
			var path10 = myDir+name10;
			var path11 = myDir2+name11;
			var path12 = myDir1+name12;
			var path13 = myDir2+name13;
			var path14 = myDir+name14;
			var path15 = myDir+name15;
			var path17 = myDir+name17;
			
// Analyzes the number of white pixels in converted image				
			run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
				setOption("BlackBackground", false);
				getHistogram(values, counts, 256);
					fiber_area = counts[0];
					white_area= counts[0];
					black_area= counts[255];
					if (fiber_area == 0){
						print("Error there are no fibers in ",name0," to analyze");
							exit();};
					
// Sets the Voronoi Analysis to monochrome 8bit image iterate and count correctly.
	run("Options...", "iterations=1 count=1 pad edm=8-bit do=Nothing");
	run("Voronoi");
	run("Brightness/Contrast...");
		setMinAndMax(0, 0);
			run("Apply LUT");
			run("Close");
		run("Make Binary");
			
//Gets number of black pixels from Voronoi Analysis	for fiber length		
				getHistogram(values, counts, 256);
					vfiber_length = counts[255];
					Voronoi_Fiber_Diameter= fiber_area/vfiber_length;

//Gets number of Voronoi Analysis intersections						
			run("Analyze Skeleton (2D/3D)", "prune=[shortest branch]");
					vthree_point= getResult("# Triple points",0);
					vfour_point= getResult("# Quadruple points",0);
			selectWindow("Results");		
				run("Close");
				run("Close");
						
// Saves B&W picture for analysis
		saveAs("Tiff", path1);	
			run("Close All");
		
				
	open(name0); 
// Runs the Medial Axis Tranformation for an alternative skeleton structure			
	open(name0);
		run("Invert");
		run("Skeletonize");
		run("Brightness/Contrast...");
		setMinAndMax(0, 0);
			run("Apply LUT");
			run("Close");
			run("Make Binary");
		
	

//Gets number of black pixels from Medial Analysis	for fiber length					
				getHistogram(values, counts, 256);
					mfiber_length = counts[255];
					Medial_Fiber_Diameter= fiber_area/mfiber_length;	

//Gets number of Medial Analysis intersections					
			run("Analyze Skeleton (2D/3D)", "prune=[shortest branch]");
					mthree_point= getResult("# Triple points",0);
					mfour_point= getResult("# Quadruple points",0);
			selectWindow("Results");		
				close();
				run("Close");
				
// Saves B&W picture for analysis
		saveAs("Tiff", path2);	
			run("Close All");

//Performs a correction for overestimation of fiber length because of intersections
			
				a= Voronoi_Fiber_Diameter; 
					do {
						b=a;
						CVoronoi_Len= vfiber_length - vthree_point*0.5*a - vfour_point*a;
							a = fiber_area/CVoronoi_Len;
						} while(a-b >= 0.001);
										
				c= Medial_Fiber_Diameter; 
					do {
						d=c;
						CMedial_Len= mfiber_length - mthree_point*0.5*c - mfour_point*c;
							c = fiber_area/CMedial_Len;
						} while(c-d >= 0.001);
				
				Corr_Medial_Fiber_length= mfiber_length - mthree_point*0.5*Medial_Fiber_Diameter - mfour_point*Medial_Fiber_Diameter;
				Corr_Medial_Fiber_Diam= fiber_area/Corr_Medial_Fiber_length;
				
				V_M_Mean= (a+Medial_Fiber_Diameter)/2;

	open(name0);
		run("OrientationJ Distribution", "log=0.0 tensor=7.0 gradient=0 min-coherency=0.0 min-energy=0.0 harris-index=on s-distribution=on hue=Gradient-X sat=Gradient-X bri=Gradient-X ");
			saveAs("Tiff", path17);
				run("Close All");
					
	open(name0);
// Analyzes the picture with distance to pixel intensity transformation	for area averaging	

		run("Invert");
		run("Skeletonize");
			run("Make Binary");
			run("Skeleton Intersections", " ");
				setOption("BlackBackground", false);
						run("Create Selection");
						run("Add to Manager");
		
		open(name0);
					run("Invert");
						run("Distance Map");				
						roiManager("Select", 0);
							setBackgroundColor(255, 255, 255);
						run("Clear Outside");
						run("Save XY Coordinates...", "background=0 invert save=[path13]");				
			
			open(name0);
					run("Invert");
					run("Skeletonize");
						run("Make Binary");
							pathfile= path13; 
								filestring=File.openAsString(pathfile); 
								rows=split(filestring, "\n"); 
								x=newArray(rows.length); 
								y=newArray(rows.length); 
								z=newArray(rows.length);
								 	for(v=0; v<rows.length; v++) 	{	 
										columns=split(rows[v],"\t"); 
										x[v]=parseInt(columns[0]); 
										y[v]=parseInt(columns[1]);
										z[v]=parseInt(columns[2]);
											setColor(0);
									fillOval(x[v]-(z[v]/sqrt(2))+1,y[v]-(z[v]/sqrt(2))+1,2*(z[v]/sqrt(2)),2*(z[v]/sqrt(2)));;
							}
							Ints = (rows.length);
							run("Create Selection");
								run("Add to Manager");
							
				open(name0);
					run("Invert");
						run("Distance Map");
							roiManager("Select", 1);
						run("Histogram");
							saveAs("Tiff", path6);
						close();

						run("Set Measurements...", "  mean standard modal integrated median skewness kurtosis redirect=None decimal=6");
							run("Measure");
								area_ave= 2*getResult("Mean",0);
								area_stdev= 2*getResult("StdDev",0);
								area_mode= 2*getResult("Mode",0);
								area_median= 2*getResult("Median",0);
									setResult("Mean",0,area_ave);
									setResult("StdDev",0,area_stdev);
									setResult("Mode",0,area_mode);
									setResult("Median",0,area_median);

							n=0;
							m=0;
							getHistogram(values, counts, 256);
								for (row=0; row<256; row++) {
									
									setResult("Radius Value", row, row);
									setResult("Radius Count", row, counts[row]);
								
								Calc_Fiber_Area= 2*values[row]*counts[row];	
								Weigh_Fiber_Area= 4*values[row]*counts[row]*values[row];
							
									n=Calc_Fiber_Area+n;
									m=Weigh_Fiber_Area+m;
										}

									W_diameter = m/n;	
						run("Flatten");									
							saveAs("tiff",path14);
								close();
						selectWindow("Results");
							saveAs("Results",path8);
								run("Clear Results");
						selectWindow("Results");
							run("Close");
						roiManager("reset");
						selectWindow("ROI Manager");
							run("Close");
						selectWindow("Log");
							run("Close");
						run("Close All");		

						
	open(name0); 				
// Analyzes dark areas from B&W picture to get pores
		run("Set Measurements...", "area standard fit shape skewness kurtosis redirect=None decimal=6");
		run("Analyze Particles...", "size=10-Infinity pixel circularity=0.00-1.00 show=Outlines display exclude clear include summarize");
		

		
		
		selectWindow("Summary");
			lines = split(getInfo(), "\n");
				headings = split(lines[0], "\t");
				values = split(lines[1], "\t");
					for (y=0; y<headings.length; y++){
					Mean_Pore_Size= values[3];}
						saveAs("Results", path12+".xls");		
			selectWindow("Summary");
			run("Close");

			if (Mean_Pore_Size == "NaN"){
				selectWindow(name0);
				run("Analyze Particles...", "size=10-Infinity pixel circularity=0.00-1.00 show=Outlines display clear include summarize");
						selectWindow("Summary");
		
			lines = split(getInfo(), "\n");
				headings = split(lines[0], "\t");
				values = split(lines[1], "\t");
					for (y=0; y<headings.length; y++){
					Mean_Pore_Size= values[3];}
			saveAs("Results", name12+".xls");

			selectWindow("Summary");
			run("Close");
						};
			
			selectWindow("Results");
				saveAs("Results", path11+".csv");					
		run("Clear Results");
			selectWindow("Results");
				run("Close");
			
			
		run("Close");
			close();
		
		
				Int_Den= Ints*10000/(white_area+black_area);
				Percent_Porosity= black_area/(white_area+black_area);
				Ave_Len= ((vfiber_length+mfiber_length)/2);
					Char_Len = Ave_Len/Ints;	
		
		
// Prints for Final Variables
			
			Var = newArray("Super Pixel","Histogram_Mean","Histogram_SD","Histogram_Mode","Histogram Median","Mean Pore Size","Percent Porosity","Intersection Density (100x100px)","Characteristic Length");
			Value_Pixels = newArray(V_M_Mean,area_ave,area_stdev,area_mode,area_median,Mean_Pore_Size,Percent_Porosity,Int_Den,Char_Len);
	
	Array.show("Total Summary",Var,Value_Pixels);
		
		selectWindow("Total Summary");
			saveAs("Results",path5);
				run("Close");
				run("Close All");

		}if (endsWith(filename, "tif")) {
		if (i == 1) {print(i+1," Images Analyzed Successfully");};
			if (i > 1) {print(i+1," Images Analyzed Successfully");};}
	}
T2 = getTime();
TTime = (T2-T1)/1000;

print("All Images Analyzed Successfully in",TTime," Seconds");
