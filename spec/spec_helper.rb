fleuve_lib_path = File.join(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'fleuve')))
$LOAD_PATH << fleuve_lib_path unless $LOAD_PATH.include?(fleuve_lib_path)
