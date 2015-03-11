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
	myDir = dir1+File.separator;

	File.makeDirectory(myDir);
		if (!File.exists(myDir))
			exit("Unable to create directory");
			print("");
		print(myDir);

// Creates custom file names for use later
	var name0=getTitle;

// Creates custom file paths for use later
	var path0 = myDir+name0;
			

			run("Invert");			
			saveAs("Tiff", path0);
	close();
	run("Close");

	}
} print("All Files Inverted Successfully!");