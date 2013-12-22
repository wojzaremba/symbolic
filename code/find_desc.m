function ret = find_desc(desc)
  global all_desc
  if (isKey(all_desc, desc))
    ret = true;
    return;
  else 
    all_desc(desc) = 1;
    ret = false; 
  end
end