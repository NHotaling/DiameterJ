//Define Crop size of all images to be analyzed and define which segmentation algorithms to use
	IJorFIJI = getVersion();
	Dialog.create("DiameterJ Options");
		if (startsWith(IJorFIJI, 1)){
			Dialog.setInsets(0, 138, 0);
			Dialog.addMessage("Orientation Analysis");
				Ana_labels = newArray("None", "OrientationJ");
					Dialog.addChoice("Orientation Analysis:", Ana_labels, "OrientationJ");
		}

		if (startsWith(IJorFIJI, 2)){
			Dialog.setInsets(0, 138, 0);
			Dialog.addMessage("Orientation Analysis");
				Ana_labels = newArray("None", "OrientationJ", "Directionality", "Both");
					Dialog.addChoice("Orientation Analysis:", Ana_labels, "OrientationJ");
				Dialog.addMessage("*Note: Directionality provides raw data but is much slower");
		}
				
		Dialog.setInsets(25, 117, 0);
		Dialog.addMessage("Automated Unit Conversion");		
			radio_items = newArray("Yes", "No");
			Dialog.setInsets(0, 0, 0);
			Dialog.addRadioButtonGroup("Do you want DiameterJ to convert all output from pixels to real units?", radio_items, 1, 2, "No")
				Dialog.addNumber("Length of scale bar", 306, 0, 7, "Pixels");
				Dialog.addNumber("Length of scale bar", 100, 0 , 7, "Microns");	
		
		Dialog.setInsets(25, 98, 0);		
		Dialog.addMessage("Identify Specific Radius Locations");		
			radio_items = newArray("Yes", "No");
			Dialog.setInsets(0, 0, 0);
			Dialog.addRadioButtonGroup("Do you want to identify the location of a specific radius?", radio_items, 1, 2, "No")
				Dialog.addNumber("Min. Fiber Radius", 1, 0, 7, "Pixels");
				Dialog.addNumber("Max. Fiber Radius", 255, 0 , 7, "Pixels");
		
		Dialog.setInsets(25, 142, 0);
		Dialog.addMessage("Batch Processing");	
			radio_items = newArray("Yes", "No");
			Dialog.setInsets(0, 0, 0);
			Dialog.addRadioButtonGroup("Do you want to analyze more than one image?", radio_items, 1, 2, "Yes")
			Dialog.setInsets(0, 0, 0);
			Dialog.addRadioButtonGroup("Do you want DiameterJ to combine analysis from all images?", radio_items, 1, 2, "Yes")
		
		Dialog.show;
			choice_orien = Dialog.getChoice();
			
			unit_conv = Dialog.getRadioButton();
			unit_pix = Dialog.getNumber();
			unit_real = Dialog.getNumber();	
			
			R_Loc = Dialog.getRadioButton();
			lowT = Dialog.getNumber();
			highT = Dialog.getNumber();			
			
			Batch_analysis = Dialog.getRadioButton();
			batch_combo = Dialog.getRadioButton();		
		
if(Batch_analysis == "Yes") {			
// Asks for a directory where Tif files are stored that you wish to analyze
	dir1 = getDirectory("Choose Source Directory");
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

// Save Batch Combined Files into a new combo folder
	if(batch_combo == "Yes"); {
		myDir3 = dir1+"Combined Files"+File.separator;

	File.makeDirectory(myDir3);
		if (!File.exists(myDir3))
			exit("Unable to create directory");	
	}

if(R_Loc == "Yes"){
// Save Analyzed B&W image into a new folder called Diameter Location
	myDir3 = dir1+"Diameter Location"+File.separator;

	File.makeDirectory(myDir3);
		if (!File.exists(myDir3))
			exit("Unable to create directory");
	};			
				
// Creates custom file names for use later
	name0= getTitle;	
	name =  newArray(name0, name0+"_Intersections.csv", name0+"_Axial_Thinning.tif",
					   name0+"_Diameter", name0+"_log", name0+"_Total Summary.csv", name0+"_Radius Plot", 
					   name0+"_Pore Data2.csv", name0+"_Radius Histo.csv", name0+"_pores", name0+"_Pore Outlines", name0+"_Pore Data",
					   name0+"_Pore Summary", name0+"_Intersection Coordinates.txt", name0+"_Euclidean", 
					   name0+"_Dilated Diam", name0+"_Intersections2.csv", name0+"_Orientation", name0+"_Compare", name0+"_EDT",
					   name0+"_Radius Location", name0+"_Orient Hist.csv"); 

	for (n = 0; n <22; n++) {
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
			var path0 = myDir+name[0];
			var path1 = myDir2+name[1];			
			var path2 = myDir+name[2];
			var path3 = myDir+name[3];
			var path4 = myDir+name[4];
			var path5 = myDir1+name[5];
			var path6 = myDir2+name[6];
			var path7 = myDir2+name[7];
			var path8 = myDir2+name[8];
			var path9 = myDir+name[9];
			var path10 = myDir+name[10];
			var path11 = myDir2+name[11];
			var path12 = myDir1+name[12];
			var path13 = myDir2+name[13];
			var path14 = myDir+name[14];
			var path15 = myDir+name[15];
			var path16 = myDir2+name[16];
			var path17 = myDir+name[17];
			var path18 = myDir+name[18];
			
		if(R_Loc == "Yes"){			
			var path19 = myDir3+name[19];
			var path20 = myDir3+name[20];	
		};			
			var path21 = myDir2+name[21];

	
// Analyzes the number of white pixels in converted image
	if(unit_conv == "Yes"){
		scale_pix = unit_pix;
		scale_unit = unit_real;
		scale_meas = "um";
			};
	if(unit_conv == "No"){
		scale_pix = 0;
		scale_unit = 0;
		scale_meas = "pixel";
			};	
			
		orig_im = name0;	
	if (endsWith(filename, "jpg") || endsWith(filename, "JPG") || endsWith(filename, "jpeg") || endsWith(filename, "JPEG") || endsWith(filename, "Jpeg") || endsWith(filename, "Jpg")) {
		run("Make Binary");
		saveAs("Tiff", dir1+name0);
			orig_im = name0;
			name0 = replace(name0,".jpg","");
			name0 = replace(name0,".JPG","");
			name0 = replace(name0,".jpeg","");
			name0 = replace(name0,".JPEG","");
			name0 = replace(name0,".Jpg","");
			name0 = replace(name0,".Jpeg","");
			name0 = name0+".tif";
				open(name0);
		};
	
		run("Set Scale...", "distance=scale_pix known=scale_unit pixel=1 unit=scale_meas");
				setOption("BlackBackground", false);
				getHistogram(values, counts, 256);
					fiber_area = counts[0];
					white_area= counts[0];
					black_area= counts[255];
					if (fiber_area == 0){
						print("Error there are no fibers in ",name0," to analyze");
							exit();};
		run("Invert");
		run("Skeletonize");
			run("Make Binary");	
		saveAs("Tiff", path2);	
			run("Close All");
			
	open(name0);
// Sets the Voronoi Analysis to monochrome 8bit image iterate and count correctly.
	run("Options...", "iterations=1 count=1 pad edm=8-bit do=Nothing");
	run("Voronoi");
	run("Brightness/Contrast...");
		setMinAndMax(0, 0);
			run("Apply LUT");
		selectWindow("B&C");
			run("Close");
		run("Make Binary");
			
//Gets number of black pixels from Voronoi Analysis	for fiber length		
				getHistogram(values, counts, 256);
					vfiber_length = counts[255];		
			run("Close All");
		
	open(name0); 
	if(unit_conv == "Yes"){
		scale_pix = unit_pix;
		scale_unit = unit_real;
		scale_meas = "um";
			};
	if(unit_conv == "No"){
		scale_pix = 0;
		scale_unit = 0;
		scale_meas = "pixel";
			};	
		run("Set Scale...", "distance=scale_pix known=scale_unit pixel=1 unit=scale_meas");
// Runs the Medial Axis Tranformation for an alternative skeleton structure			
	open(path2+".tif");

//Gets number of black pixels from Medial Analysis	for fiber length					
				getHistogram(values, counts, 256);
					mfiber_length = counts[255];
					Medial_Fiber_Diameter= fiber_area/mfiber_length;	

//Gets number of Medial Analysis intersections and lengths between intersections					
			run("Analyze Skeleton (2D/3D)", "prune=[shortest branch]");
				selectWindow("Tagged skeleton");
				close();
				
				selectWindow("Results");
					mthree_point= getResult("# Junctions",0);
					mfour_point= getResult("# Quadruple points",0);
					mthree_point= mthree_point - mfour_point;
				run("Close");
			run("Close All");

//Performs a correction for overestimation of fiber length because of intersections
			
				c= Medial_Fiber_Diameter; 
					do {
						d=c;
						CMedial_Len= mfiber_length - mthree_point*0.5*c - mfour_point*c;
							c = fiber_area/CMedial_Len;
						} while(c-d >= 0.001);
						
				CMFiber_Diam= c;
			CVfiber_Length = vfiber_length- mthree_point*0.5*c - mfour_point*c;
			CVfiber_Diam = fiber_area/CVfiber_Length;
				V_M_Mean = (CVfiber_Diam+CMFiber_Diam)/2;
				
// Detailed intersection analysis
	open(name0);
	if(unit_conv == "Yes"){
		scale_pix = unit_pix;
		scale_unit = unit_real;
		scale_meas = "um";
			};
	if(unit_conv == "No"){
		scale_pix = 0;
		scale_unit = 0;
		scale_meas = "pixel";
			};	
		run("Set Scale...", "distance=scale_pix known=scale_unit pixel=1 unit=scale_meas");
		
open(path2+".tif");
//Gets number of Medial Analysis intersections and lengths between intersections					
			run("Analyze Skeleton (2D/3D)", "prune=[shortest branch] show");
			selectWindow("Results");
				run("Close");
			selectWindow("Tagged skeleton");
				close();
				
	selectWindow("Branch information");
				saveAs("Results",path1);
				run("Close");
				
	open(path1);
		if(batch_combo == "Yes"){
			saveAs("Results", path16);
		}
		run("Summarize");
			Char_Length_Mean = getResult("Branch length",nResults-4);
			Char_Length_SD = getResult("Branch length",nResults-3);
			Char_Length_Max = getResult("Branch length",nResults-1);
		saveAs("Results",path1);
			selectWindow("Results");
				run("Close");	

// Fiber Orientation calculations with OrientationJ
if(choice_orien == "OrientationJ" || choice_orien == "Both"){			
		open(path2+".tif");
				run("Create Selection");
					run("Enlarge...", "enlarge=1");
					setForegroundColor(0, 0, 0);
					run("Fill", "slice");
					run("Select All");
		run("OrientationJ Distribution", "log=0.0 tensor=9.0 gradient=0 min-coherency=5.0 min-energy=0.0 harris-index=on s-distribution=on hue=Gradient-X sat=Gradient-X bri=Gradient-X ");
			saveAs("Tiff", path17);
				run("Close All");
	};
		
// Fiber Orientation calculations with Directionality
if(choice_orien == "Directionality" || choice_orien == "Both"){
	open(path2+".tif");
			run("Create Selection");
				run("Enlarge...", "enlarge=1");
				setForegroundColor(0, 0, 0);
				run("Fill", "slice");
				run("Select All");
		run("Directionality", "method=[Fourier components] nbins=180 histogram=-90 display_table");
			act_win = "Directionality histograms for DUP_"+name[2]+" (using Fourier components)";
			act_win = replace(act_win,".tif","");
				selectWindow(act_win);
			saveAs("Results", path21);
				selectWindow(name[21]);
				run("Close");	
	};				
	
// Analyzes the picture with distance to pixel intensity transformation	for area averaging	
		open(path2+".tif");
			run("Skeleton Intersections", " ");
				setOption("BlackBackground", false);
						run("Create Selection");
						roiManager("Add");
		
		open(name0);
			run("Invert");
				run("Distance Map");	
				roiManager("Select", 0);
					setBackgroundColor(255, 255, 255);
				run("Clear Outside");
				run("Save XY Coordinates...", "background=0 invert save=[path13]");				
			
		open(path2 + ".tif");
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
								roiManager("Add");
					
		open(name0);
			run("Invert");
				run("Distance Map");
					roiManager("Select", 1);
				run("Histogram");
					saveAs("Tiff", path6);
				close();
				print("\\Clear");
				print("Analyzing image: ",list[i]);

				run("Set Measurements...", "area modal min integrated median skewness kurtosis redirect=None decimal=6");
					run("Measure");
						area_mode= 2*getResult("Mode",0);
						area_median= 2*getResult("Median",0);
						area_min =  2*getResult("Min",0);
						area_max = 2*getResult("Max",0);
						area_intden = getResult("IntDen",0);
						area_length = getResult("Area",0);
						area_skew = getResult("Skew",0);
						area_kurt = getResult("Kurt",0);
						area_rawintden = getResult("RawIntDen",0);
							run("Clear Results");
																		
// Creates a matrix with all radius and count values in it

						getHistogram(values, counts, 256);
							Radius_Values = values;
							Frequency = counts;
								Array.show("Total Summary2",Radius_Values, Frequency);

// Fits a Gaussian to the Radius data and gets center, SD, and 	height info.							
							Fit.doFit("Gaussian",Radius_Values, Frequency);
								area_ave = 2*Fit.p(2);
								area_stdev = 2*Fit.p(3);
								area_height = Fit.p(2)-Fit.p(1);
	
// Saves an overlay of the centerline on the EDT
						run("Flatten");									
							saveAs("tiff",path14);
								close();

// Creates Variables with the values from the results table and saves the results table.							
						selectWindow("Total Summary2");
							saveAs("Results", path8);
							run("Close");
						roiManager("reset");
						selectWindow("Results");
							run("Close");
	
// Converts the radius histogram into a histogram of given units				
	if(unit_conv == "Yes"){
		scale_pix = unit_pix;
		scale_unit = unit_real;
			pathfile= path8; 
				filestring=File.openAsString(pathfile); 
				rows=split(filestring, "\n"); 
				Radius_Values = newArray(rows.length); 
				Frequency = newArray(rows.length); 
					for(v=1; v<rows.length; v++) 	{	 
						columns=split(rows[v],","); 
						Radius_Values[v]=parseInt(columns[0])*(scale_unit/scale_pix); 
						Frequency[v]=parseInt(columns[1]);
					}
					
					Radius_Values = Array.slice(Radius_Values,1);
					Frequency = Array.slice(Frequency,1);
				Array.show("Converted Histogram",Radius_Values,Frequency);
				selectWindow("Converted Histogram");
					saveAs("Results", path8);
				run("Close");
		
	};							

// Creates an analysis for the location of particular fiber radii						
if(R_Loc == "Yes"){						
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");		
		open(path2+".tif");
			run("Skeleton Intersections", " ");
				setOption("BlackBackground", false);
						run("Create Selection");
						roiManager("Add");
						close();
	
			
		open(name0);
					run("Invert");
						run("Distance Map");
							saveAs("Tiff", path19);						
						close();
	
	
// Creates circles at each intersection that subtract out intersection points
			open(path2+".tif");
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
							run("Create Selection");
								roiManager("Add");
	
								
// Overlays the centerline with subtracted intersections onto the distance map.
					open(path19+".tif");
							roiManager("Select", 1);
								run("Clear Outside");
								setAutoThreshold("Default dark");
									setThreshold(lowT, highT);
										setOption("BlackBackground", false);
											run("Convert to Mask");
											run("Create Selection");
											roiManager("Add");
	
											

// Overlays specific radii onto original segmented image for visual analysis 				
				open(name0);
					roiManager("Select", 2);
						run("Enlarge...", "enlarge=1");
						setForegroundColor(255, 0, 0);
							run("RGB Color");
								setColor(255,0,0);
									run("Fill", "slice");
						saveAs("Tiff", path20);
						roiManager("reset");
						run("Close All");	

					
	File.delete(path19+".tif");
						selectWindow("Log");
							run("Close");
							run("Close All");
	print("Analyzing image: ",list[i]);							
	}	

	open(name0); 	
		run("Set Scale...", "distance=scale_pix known=scale_unit pixel=1 unit=scale_meas");	
// Analyzes dark areas from B&W picture to get pores
		run("Set Measurements...", "area perimeter fit shape redirect=None decimal=4");
		call("ij.plugin.filter.ParticleAnalyzer.setFontSize", 24); 
			run("Analyze Particles...", "size=10-Infinity pixel circularity=0.00-1.00 show=Outlines display exclude clear include summarize");
			Pore_N = nResults;
			saveAs("tiff",path9);
			
		selectWindow("Summary");
			lines = split(getInfo(), "\n");
				headings = split(lines[0], "\t");
				values = split(lines[1], "\t");
					for (y=0; y<headings.length; y++){
					Mean_Pore_Size= values[3];}
			selectWindow("Summary");
			run("Close");

			if (Mean_Pore_Size == "NaN"){
				selectWindow(name0);
				run("Analyze Particles...", "size=10-Infinity pixel circularity=0.00-1.00 show=Outlines display clear include summarize");
				Pore_N = nResults;
					saveAs("tiff",path9);
					selectWindow("Summary");
					run("Close");
				};
			

			selectWindow("Results");
			
			if(batch_combo == "Yes"){
				saveAs("Results", path7);	
			};
				run("Summarize");
					Pore_Max = getResult("Area",nResults-1);
					Pore_Min = getResult("Area",nResults-2);
					Pore_SD = getResult("Area",nResults-3);
					Mean_Pore_Size = getResult("Area",nResults-4);
				saveAs("Results", path11+".csv");					
			run("Clear Results");
				selectWindow("Results");
					run("Close");
					
		run("Close");
			close();
		
		Int_Den= Ints*10000/(white_area+black_area);
		Percent_Porosity= black_area/(white_area+black_area);
		Ave_Len= (CVfiber_Length+CMedial_Len)/2;
		Char_Len = Ave_Len/Ints;

// Conversion of Variables to real units
	if(unit_conv == "Yes"){
		scale_pix = unit_pix;
		scale_unit = unit_real;
			};
	if(unit_conv == "No"){
		scale_pix = 1;
		scale_unit = 1;
			};
	
		V_M_Mean = V_M_Mean*(scale_unit/scale_pix);
		area_ave = area_ave*(scale_unit/scale_pix);
		area_stdev = area_stdev*(scale_unit/scale_pix);
		area_mode = area_mode*(scale_unit/scale_pix);
		area_median = area_median*(scale_unit/scale_pix);
		area_min = area_min*(scale_unit/scale_pix);
		area_max = area_max*(scale_unit/scale_pix);
		area_intden = area_intden*(scale_unit/scale_pix);
		area_rawintden = area_rawintden*(scale_unit/scale_pix);
		area_length = area_length*(scale_unit/scale_pix);
	
	if(unit_conv == "Yes"){
		Int_Den = (Ints/(white_area+black_area))*(scale_pix/scale_unit)*(scale_pix/scale_unit);
		Int_Den = d2s(Int_Den, -5);
		Char_Len = Char_Len*(scale_unit/scale_pix);
		};

if(unit_conv == "No"){			
// Prints for Final Variables
			
			Diameter_Metrics = newArray("Super Pixel","Histogram Mean","Histogram SD","Histogram Mode","Histogram Median", "Histogram Min Diam.", "Histogram Max Diam.", "Histogram Integrated Density", "Histogram Raw Integrated Density", "Diameter Skewness", "Diameter Kurtosis", "Fiber Length");
			Other_Metrics = newArray("Mean Pore Area", "Pore Area SD","Min. Pore Area","Max. Pore Area", "Percent Porosity", "Number of Pores", "# of Intersections", "Intersection Density (100x100px)","Char. Length", "SD Char. Length", "Max Span Length", "Old Char. Length (Tot. Fiber Len./# intersections)");
			Diameter_Values = newArray(V_M_Mean,area_ave,area_stdev,area_mode,area_median,area_min,area_max,area_intden,area_rawintden,area_skew,area_kurt,area_length);
			Values = newArray(Mean_Pore_Size,Pore_SD,Pore_Min,Pore_Max,Percent_Porosity,Pore_N,Ints,Int_Den,Char_Length_Mean,Char_Length_SD,Char_Length_Max,Char_Len);
			_ = newArray(" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ");
			};

if(unit_conv == "Yes"){			
// Prints for Final Variables
			
			Diameter_Metrics = newArray("Super Pixel (um)","Histogram Mean (um)","Histogram SD (um)","Histogram Mode (um)","Histogram Median (um)", "Histogram Min Diam. (um)", "Histogram Max Diam. (um)", "Histogram Integrated Density", "Histogram Raw Integrated Density", "Diameter Skewness", "Diameter Kurtosis", "Fiber Length (um)");
			Other_Metrics = newArray("Mean Pore Area (um^2)", "Pore Area SD (um^2)","Min. Pore Area (um^2)","Max. Pore Area (um^2)", "Percent Porosity", "Number of Pores", "# of Intersections", "Intersection Density (Ints/um^2)","Char. Length (um)", "SD Char. Length (um)", "Max Span Length (um)", "Old Char. Length (Tot. Fiber Len./# intersections) (um)");
			Diameter_Values = newArray(V_M_Mean,area_ave,area_stdev,area_mode,area_median,area_min,area_max,area_intden,area_rawintden,area_skew,area_kurt,area_length);
			Values = newArray(Mean_Pore_Size,Pore_SD,Pore_Min,Pore_Max,Percent_Porosity,Pore_N,Ints,Int_Den,Char_Length_Mean,Char_Length_SD,Char_Length_Max,Char_Len);
			_ = newArray(" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ");
			};			

	
	Array.show("Total Summary",Diameter_Metrics,Diameter_Values,_,Other_Metrics,Values);
		
		selectWindow("Total Summary");
			saveAs("Results",path5);
				run("Close");
				run("Close All");
				
// Creates a montage of the areas measured
	open(name0);
		run("Invert");
	open(path2+".tif");
		run("Invert");
	open(path14+".tif");
	open(path9+".tif");	

		run("Images to Stack", "method=[Scale (smallest)] name=Stack title=[] use");
			selectWindow("Stack");

					run("RGB Color");
						setForegroundColor(175,0,0);
				run("Make Montage...", "columns=2 rows=2 scale=1.0 first=1 last=4 increment=1 border=5 font=25 label use");

// Saves montage image
		saveAs("PNG", path18);
		run("Close");
		run("Close");
			
	setForegroundColor(0,0,0);	
		File.delete(path13);
		File.delete(path2+".tif");
		File.delete(path9+".tif");
		File.delete(path14+".tif");
	if (endsWith(orig_im, "jpg") || endsWith(orig_im, "JPG") || endsWith(orig_im, "jpeg") || endsWith(orig_im, "JPEG") || endsWith(orig_im, "Jpeg") || endsWith(orig_im, "Jpg")) {
		File.delete(dir1+name0);
	};
		print("\\Clear");
			run("Close All");				
			

		}
	}
}


	
//Analysis for Combining radius histograms
	if(batch_combo == "Yes") {
		print("\\Clear");
			list2 = getFileList(myDir2);
			setBatchMode(true);
		for (ij=0; ij<list2.length; ij++) {
			showProgress(ij+1, list2.length);
			filedir1 = myDir2 + list2[ij];
			
			filename1 = list2[ij];
			sublist1 = newArray(list2.length);

// Creates a log with only files that end with the extension of interest
			if (endsWith(filedir1, "_Radius Histo.csv")) {
				print(filename1);
				}
				}
				selectWindow("Log");
					saveAs("Text", myDir2+"rad_files.txt");
				print("\\Clear");


//Opens file that contains the names of the files of interest
		filestring1=File.openAsString(myDir2+"rad_files.txt"); 
			radrows=split(filestring1, "\n"); 
				l1 = radrows.length;
	if(l1 == 1) {
			print("Batch Analysis Not Needed.  Please open the image \n in ImageJ and run DiameterJ in non-batch mode");
			exit();
	}

//Creates a list of each of the files of interest
			for(ij=0; ij < l1; ij++) {
				filename2 = radrows[ij];
				
//Opens files of interest and parses them into new variable values					
			open(myDir2 + filename2);
				n = nResults;
				radval = newArray(n);
				freqval = newArray(n);
				for (ik=0; ik<n; ik++) {
				  radval[ik] = getResult('Radius_Values', ik);
				  freqval[ik] = getResult('Frequency', ik);
				}
			run("Clear Results");

// Sets up initial results storage file for each set of values of interest			
		if(ij==0){
			for (il=0; il<n; il++) {
				setResult("Radius", il, radval[il]);
				setResult(filename2, il, freqval[il]);	
			}
			selectWindow("Results");
			IJ.renameResults("temp.csv");
				saveAs("Results", myDir2+"temp.csv");
			run("Close");
		}

// Adds current values of interest to saved storage file		
		if(ij>0 && ij < l1-1){
			selectWindow("Results");
				run("Close");
			open(myDir2 + "temp.csv");
			for (im=0; im<n; im++) {
				setResult(filename2, im, freqval[im]);
			}
				selectWindow("Results");
					IJ.renameResults("temp.csv");
						saveAs("Results", myDir2+"temp.csv");
				run("Close");
		}
		
// Adds current values of interest to saved storage file		
		if(ij == l1-1){
			selectWindow("Results");
				run("Close");
			open(myDir2 + "temp.csv");
			for (im=0; im<n; im++) {
				setResult(filename2, im, freqval[im]);
			}
				selectWindow("Results");
					IJ.renameResults("All Radius Values.csv");
						saveAs("Results", myDir2+"All_Radius_Values.csv");
				run("Close");
				File.delete(myDir2+"temp.csv");
				File.delete(myDir2+"rad_files.txt");
				print("\\Clear");
			}
		}
		open(myDir2 + "All_Radius_Values.csv");
			n = nResults;
						
			for (j=0; j<n; j++) {
				c = 0; 
					for(i=0; i<radrows.length; i++){
						d=c;
						c = getResult(radrows[i],j);
						c = d + c;
					} 
					setResult("Sum of Frequencies", j, c);
					}
				saveAs("Results", myDir3+"All_Radius_Values.csv");
				File.delete(myDir2+"All_Radius_Values.csv");
				run("Close");
				print("\\Clear");
		}

		
		
		
//Analysis for Combining Intersections		
	if(batch_combo == "Yes") {
		print("\\Clear");
			list2 = getFileList(myDir2);
			setBatchMode(true);
		for (ij=0; ij<list2.length; ij++) {
			showProgress(ij+1, list2.length);
			filedir1 = myDir2 + list2[ij];
			
			filename1 = list2[ij];
			sublist1 = newArray(list2.length);

// Creates a log with only files that end with the extension of interest
			if (endsWith(filedir1, "_Intersections2.csv")) {
				print(filename1);
				}
				}
				selectWindow("Log");
					saveAs("Text", myDir2+"int_files.txt");
				print("\\Clear");

//Opens file that contains the names of the files of interest
		filestring1=File.openAsString(myDir2+"int_files.txt"); 
			radrows=split(filestring1, "\n"); 
				l1 = radrows.length;
				charlen_len = newArray(l1);
//Creates a list of each of the files of interest
			for(ij=0; ij < l1; ij++) {
				filename2 = radrows[ij];
				filedir2 = myDir2 + filename2;
				
//Opens files of interest and parses them into new variable values					
			open(filedir2);
				n = nResults;
				charlen_len[ij] = n;
				intval = newArray(n);
				eucval = newArray(n);
				fnamenew = newArray(n);
				for (ik=0; ik<n; ik++) {
				  intval[ik] = getResult('Branch length', ik);
				  eucval[ik] = getResult('Euclidean distance', ik);
				  fnamenew[ik] = filename2; 
				  }
				run("Clear Results");

// Sets up initial results storage file for each set of values of interest			
		if(ij==0){
			for (il=0; il<n; il++) {
				setResult("Char. Length", il, intval[il]);
				setResult("Eucl. Length", il, eucval[il]);
				setResult("File Name", il, fnamenew[il]);
			} 
			selectWindow("Results");
			IJ.renameResults("temp.csv");
				saveAs("Results", myDir2+"temp.csv");
			run("Close");
			File.delete(filedir2);
				print("\\Clear");
		}

// Adds current values of interest to saved storage file		
		if(ij>0 && ij < l1-1){
			selectWindow("Results");
				run("Close");

//Opens Initial set of stored values and enters the data into variables				
			open(myDir2 + "temp.csv");
				old_len = nResults;
				oldclen = newArray(old_len);
				oldelen = newArray(old_len);
				oldfname = newArray(old_len);
			for (im=0; im<old_len; im++) {
				oldclen[im] = getResult("Char. Length", im);
				oldelen[im] = getResult("Eucl. Length", im);
				oldfname[im] = getResultString("File Name", im);
			}
			
//Concatenates old data and new data together
			newclen = Array.concat(oldclen, intval);
			newelen = Array.concat(oldelen, eucval);
			newfname = Array.concat(oldfname, fnamenew);
			
			n= newclen.length;
			run("Clear Results");

//Creates a results table with new combined data saves it			
			for (il=0; il<n; il++) {
				setResult("Char. Length", il, newclen[il]);
				setResult("Eucl. Length", il, newelen[il]);
				setResult("File Name", il, newfname[il]);
			} 
			
				selectWindow("Results");
					IJ.renameResults("temp.csv");
						saveAs("Results", myDir2+"temp.csv");
				run("Close");
				File.delete(filedir2);
				print("\\Clear");
		}
		
// Adds current values of interest to saved storage file		
		if(ij == l1-1){
			selectWindow("Results");
				run("Close");

//Opens Initial set of stored values and enters the data into variables				
			open(myDir2 + "temp.csv");
				old_len = nResults;
				oldclen = newArray(old_len);
				oldelen = newArray(old_len);
				oldfname = newArray(old_len);
			for (im=0; im<old_len; im++) {
				oldclen[im] = getResult("Char. Length", im);
				oldelen[im] = getResult("Eucl. Length", im);
				oldfname[im] = getResultString("File Name", im);
			}
			
//Concatenates old data and new data together
			newclen = Array.concat(oldclen, intval);
			newelen = Array.concat(oldelen, eucval);
			newfname = Array.concat(oldfname, fnamenew);
			
			n= newclen.length;
			run("Clear Results");
			
//			clensum = Array.getStatistics(newclen, min, max, mean, stdDev);
//			elensum = Array.getStatistics(newelen, min, max, mean, stdDev);

//Creates a results table with new combined data saves it			
			for (il=0; il<n; il++) {
				setResult("Char. Length", il, newclen[il]);
				setResult("Eucl. Length", il, newelen[il]);
				setResult("File Name", il, newfname[il]);
			} 				
				selectWindow("Results");
					IJ.renameResults("All Char Length Values.csv");
						saveAs("Results", myDir3+"All Char Length Values.csv");
				run("Close");
				File.delete(myDir2+"temp.csv");
				File.delete(myDir2+"int_files.txt");
				File.delete(filedir2);
				print("\\Clear");
			}
			
		}
		}

// Analysis for combining pore areas 
	if(batch_combo == "Yes") {
		print("\\Clear");
			list2 = getFileList(myDir2);
			setBatchMode(true);
		for (ij=0; ij<list2.length; ij++) {
			showProgress(ij+1, list2.length);
			filedir1 = myDir2 + list2[ij];
			filename1 = list2[ij];

// Creates a log with only files that end with the extension of interest
			if (endsWith(filedir1, "_Pore Data2.csv")) {
				print(filename1);
				}
				}
				selectWindow("Log");
					saveAs("Text", myDir2+"pore_files.txt");
				print("\\Clear");

//Opens file that contains the names of the files of interest
		filestring1=File.openAsString(myDir2+"pore_files.txt"); 
			radrows=split(filestring1, "\n"); 
				l2 = radrows.length;

//Creates a list of each of the files of interest
			for(ij=0; ij < l2; ij++) {
				filename2 = radrows[ij];
				filedir2 = myDir2 + filename2;


//Opens files of interest and parses them into new variable values	
			open(filedir2);
				n = nResults;
				poreval = newArray(n);
				poremaj = newArray(n);
				poremin = newArray(n);
				porenamenew = newArray(n);
				for (ik=0; ik<n; ik++) {
					poreval[ik] = getResult("Area", ik);
					poremaj[ik] = getResult("Major", ik);
					poremin[ik] = getResult("Minor", ik);
					porenamenew[ik] = filename2; 
				}
				run("Clear Results");

// Sets up initial results storage file for each set of values of interest			
		if(ij==0){
			for (il=0; il<n; il++) {
				setResult("Pore Area", il, poreval[il]);
				setResult("Major Pore Axis", il, poremaj[il]);
				setResult("Minor Pore Axis", il, poremin[il]);
				setResult("File Name", il, porenamenew[il]);
			} 
		
			selectWindow("Results");
			IJ.renameResults("temp.csv");
				saveAs("Results", myDir2+"temp.csv");
			run("Close");
				File.delete(filedir2);
				print("\\Clear");
		}

// Adds current values of interest to saved storage file		
		if(ij>0 && ij < l2-1){
			selectWindow("Results");
				run("Close");
	
		open(myDir2 + "temp.csv");
			old_len = nResults;
			old_porearea = newArray(old_len);
			old_poremaj = newArray(old_len);
			old_poremin = newArray(old_len);
			oldporename = newArray(old_len);

			for (im=0; im<old_len; im++) {
				old_porearea[im] = getResult("Pore Area", im);
				old_poremaj[im] = getResult("Major Pore Axis", im);
				old_poremin[im] = getResult("Minor Pore Axis", im);
				oldporename[im] = getResultString("File Name", im);
			}
			
//Concatenates old data and new data together
			newpore_area = Array.concat(old_porearea, poreval);
			newpore_maj = Array.concat(old_poremaj, poremaj);
			newpore_min = Array.concat(old_poremin, poremin);
			newporename = Array.concat(oldporename, porenamenew);

			n= newpore_area.length;
			run("Clear Results");
			
			for (il=0; il<n; il++) {
				setResult("Pore Area", il, newpore_area[il]);
				setResult("Major Pore Axis", il, newpore_maj[il]);
				setResult("Minor Pore Axis", il, newpore_min[il]);
				setResult("File Name", il, newporename[il]);
			} 
			
				selectWindow("Results");
					IJ.renameResults("temp.csv");
						saveAs("Results", myDir2+"temp.csv");
					run("Close");
				File.delete(filedir2);
				print("\\Clear");
		}

// Adds current values of interest to saved storage file		
		if(ij == l2-1){
			selectWindow("Results");
				run("Close");
		
		open(myDir2 + "temp.csv");
			old_len = nResults;
			old_porearea = newArray(old_len);
			old_poremaj = newArray(old_len);
			old_poremin = newArray(old_len);
			oldporename = newArray(old_len);

			for (im=0; im<old_len; im++) {
				old_porearea[im] = getResult("Pore Area", im);
				old_poremaj[im] = getResult("Major Pore Axis", im);
				old_poremin[im] = getResult("Minor Pore Axis", im);
				oldporename[im] = getResultString("File Name", im);
			}
			
			newpore_area = Array.concat(old_porearea, poreval);
			newpore_maj = Array.concat(old_poremaj, poremaj);
			newpore_min = Array.concat(old_poremin, poremin);
			newporename = Array.concat(oldporename, porenamenew);
			
			n= newpore_area.length;
			run("Clear Results");
			
//			pareasum = Array.getStatistics(newpore_area, min, max, mean, stdDev);
//			pmajsum = Array.getStatistics(newpore_maj, min, max, mean, stdDev);
//			pminsum = Array.getStatistics(newpore_min, min, max, mean, stdDev);
			
			for (il=0; il<n; il++) {
				setResult("Pore Area", il, newpore_area[il]);
				setResult("Major Pore Axis", il, newpore_maj[il]);
				setResult("Minor Pore Axis", il, newpore_min[il]);
				setResult("File Name", il, newporename[il]);
			} 
				
				selectWindow("Results");
					IJ.renameResults("All Pore Area Values.csv");
						saveAs("Results", myDir3+"All Pore Area Values.csv");
				run("Close");
				File.delete(myDir2+"temp.csv");
				File.delete(myDir2+"pore_files.txt");
				File.delete(filedir2);
				print("\\Clear");
			}
			
		}
	}

	
	
// Combine Summary files into one output file	
if(batch_combo == "Yes") {
		print("\\Clear");
			list3 = getFileList(myDir1);
			setBatchMode(true);
		for (ij=0; ij<list3.length; ij++) {
			showProgress(ij+1, list3.length);
			filedir3 = myDir1 + list3[ij];
			filename3 = list3[ij];

			l3 = list3.length;
				

				
//Opens files of interest and parses them into new variable values					
			open(filedir3);
				n = nResults;
				diammet = newArray(n);
				diamval = newArray(n);
				othmet = newArray(n);
				othval = newArray(n);
				for (ik=0; ik<n; ik++) {
				  diammet[ik] = getResultString('Diameter_Metrics', ik);
				  diamval[ik] = getResult('Diameter_Values', ik);
				  othmet[ik] = getResultString('Other_Metrics', ik);
				  othval[ik] = getResult('Values', ik);
				  }
				run("Clear Results");
				
				totmets = Array.concat(diammet, othmet);
				totvals = Array.concat(diamval, othval);
				newlen2 = totmets.length;
				

// Sets up initial results storage file for each set of values of interest			
		if(ij==0){
			for (il=0; il<newlen2; il++) {
				setResult("Metric", il, totmets[il]);
				setResult(filename3, il, totvals[il]);
			} 
			
			selectWindow("Results");
			IJ.renameResults("temp2.csv");
				saveAs("Results", myDir1+"temp2.csv");
			run("Close");
		}
	
// Adds current values of interest to saved temporary storage file		
		if(ij>0 && ij < l1-1){
			selectWindow("Results");
				run("Close");

//Opens Initial set of stored values and enters the data into variables				
			open(myDir1 + "temp2.csv");

//Sets data as new column in temp file with the file name as the column heading
			for (im=0; im<newlen2; im++) {
				setResult(filename3, im, totvals[im]);
			}	
	
		selectWindow("Results");
			IJ.renameResults("temp2.csv");
				saveAs("Results", myDir1+"temp2.csv");
			run("Close");
		}
		
// Adds values of interest from final summary file to a final output file				
		if(ij == l1-1){
			selectWindow("Results");
				run("Close");
				
//Opens Initial set of stored values and enters the data into variables				
			open(myDir1 + "temp2.csv");

//Sets data as new column in temp file with the file name as the column heading
			for (im=0; im<newlen2; im++) {
				setResult(filename3, im, totvals[im]);
			}	
			selectWindow("Results");
				IJ.renameResults("All Summary File Values.csv");
					saveAs("Results", myDir3+"All Summary File Values.csv");
			run("Close");
			File.delete(myDir1+"temp2.csv");
			print("\\Clear");
	}
	}
	}
	
		
T2 = getTime();
TTime = (T2-T1)/1000;

print("All Images Analyzed Successfully in",TTime," Seconds");
