FilenameFilter soundFileFilter = new FilenameFilter(){
  public boolean accept(File dir, String name) {
    String lowercaseName = name.toLowerCase();
    return (!lowercaseName.startsWith(".") && lowercaseName.endsWith(".wav") || lowercaseName.endsWith(".aif"));
  }
};
    
// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  // See: https://docs.oracle.com/javase/6/docs/api/java/io/File.html
  
  if (file.isDirectory()) {
    String names[] = file.list(soundFileFilter);
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}