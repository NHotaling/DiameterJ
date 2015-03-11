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
	myDir = dir1+"Diameter Location"+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");


// Creates custom file names for use later
	
	var name0= getTitle;
	var name1= getTitle+"_Intersections";
	var name2= getTitle+"_Skeleton";
	var name3= getTitle+"_EDT";
	var name4= getTitle+"_Overlay";
	

		var path0 = myDir+name0;
		var path1 = myDir+name1;
		var path2 = myDir+name2;	
		var path3 = myDir+name3;			
		var path4 = myDir+name4;

run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");		
	run("Invert");
		run("Skeletonize");
		saveAs("Tiff", path2);
			run("Make Binary");
			run("Skeleton Intersections", " ");
				setOption("BlackBackground", false);
						run("Create Selection");
						run("Add to Manager");
		open(name0);
					run("Invert");
						run("Distance Map");
							saveAs("Tiff", path3);						
						roiManager("Select", 0);
							setBackgroundColor(255, 255, 255);
						run("Clear Outside");
						run("Save XY Coordinates...", "background=0 invert save=[path1]");				

// Creates circles at each intersection that subtract out intersection points
			open(path2+".tif");
						run("Make Binary");
							pathfile= path1; 
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
								
// Overlays the centerline with subtracted intersections onto the distance map.
					open(path3+".tif");
							roiManager("Select", 1);
								run("Clear Outside");
						lowT= getNumber("Minimum Fiber Diameter to View(Pixels)",0);
						highT= getNumber("Maximum Fiber Diameter to View (Pixels)",255);	
								setAutoThreshold("Default dark");
									//run("Threshold...");
										setThreshold(lowT, highT);
											setOption("BlackBackground", false);
												run("Convert to Mask");
												run("Create Selection");
												run("Add to Manager");
				open(name0);
					roiManager("Select", 2);
						run("Enlarge...", "enlarge=1");
						setForegroundColor(255, 0, 0);
							run("RGB Color");
								setColor(255,0,0);
									run("Fill", "slice");
						saveAs("Tiff", path4);
						roiManager("reset");
						selectWindow("ROI Manager");
							run("Close");
						run("Close All");	
						
	File.delete(path1);
	File.delete(path2+".tif");
	File.delete(path3+".tif");	
						selectWindow("Log");
							run("Close");
						}if (endsWith(filename, "tif")) {
		if (i == 1) {print(i+1," Images Analyzed Successfully");};
			if (i > 1) {print(i+1," Images Analyzed Successfully");};}
	}
T2 = getTime();
TTime = (T2-T1)/1000;

print("All Images Analyzed Successfully in",TTime," Seconds");