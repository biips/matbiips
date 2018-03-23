function ok = check_mex()
%CHECK_MEX check matbiips mexfile is working
% ok = check_mex()
%--------------------------------------------------------------------------

ok = exist('matbiips', 'file') == 3;
if ok
  try
      matbiips
  catch ME
      ok = strcmp(ME.identifier, 'matbiips:noArgs');
  end
end
end