function Init()
  global prime dot_mult all_desc all_bulk_hashes n_ m_
  prime = 1000000000000000001;
  val = 1;
  dot_mult = zeros(100000, 1);
  for i = 1:100000
    val = mod(val * 100000000001, prime);
    dot_mult(i) = val;
  end
  all_desc = containers.Map;
  all_bulk_hashes = containers.Map('KeyType', 'double', 'ValueType', 'any');
  addpath(genpath('.'));
  home = '/Users/wojto';
  external_tools = [home, '/Dropbox/external/'];  
  addpath([external_tools, 'mosek/7/toolbox/r2013a']);
  setenv('MOSEKLM_LICENSE_FILE', [external_tools, 'mosek/mosek.lic']);  
  setenv('LD_LIBRARY_PATH', [external_tools, 'mosek/7/tools/platform/osx64x86/bin']);   
  n_ = 99;
  m_ = 100;
end