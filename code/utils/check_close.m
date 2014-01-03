function check_close(A, B, name)
  eps = 1e-4;
  if (norm(A - B) / norm(A(:)) < eps)
    printf('\t %s PASSED\n', name);
  else
    if (imag(A) ~= 0)
      printf('WARNING IMAGINARY PART\t');
    end
    printf('FAILED %s, %f != %f\n', name, A, B);
  end
end
