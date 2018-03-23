clear -variables
close all

olddir = cd('../private');

out1 = parse_varname('x[1:2]');
assert(out1.name == 'x') 
assert(out1.lower == 1)
assert(out1.upper == 2)

out2 = parse_varname('x');
assert(out2.name == 'x')
assert(isempty(out2.lower))
assert(isempty(out2.upper))

out3 = parse_varname('xy[1,2:3]');
assert(all(out3.name == 'xy'))
assert(all(out3.lower == [1;2]))
assert(all(out3.upper == [1;3]))

cd(olddir)
