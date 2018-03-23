function tests = run_tests()

global tests_

if ispc
    % Windows
    tests_ = struct('Name',{
        'test_console'
        'test_internals'
        'test_smc'
%         'test_pimh' %[CRASHES]
        'test_pmmh'
        'test_pmmh2' %[FAILS]
        'test_funcmat'
        'test_distmat'
        'test_crash1'
        'test_crash2'
%         'test_crash3' %[CRASHES]
%         'test_crash5' %[CRASHES]
%         'test_crash6' %[CRASHES]
%         'test_crash7' %[CRASHES]
        });
else
    % Linux, OSX
    tests_ = struct('Name',{
        'test_console'
        'test_internals'
        'test_smc'
        'test_pimh'
        'test_pmmh'
        'test_pmmh2' %[FAILS]
        'test_funcmat'
        'test_distmat'
        'test_crash1'
        'test_crash2'
        'test_crash3'
        'test_crash5'
        'test_crash6'
        'test_crash7'
        });
end

for i=1:numel(tests_)
    fprintf('Running %s\n', tests_(i).Name)
    
    tests_(i).Failed = trytest(tests_(i).Name);
    
    fprintf('.\nDone %s\n', tests_(i).Name)
    fprintf('__________\n\n')
end

fprintf('Failure Summary:\n\n')
fprintf('     Name                 Failed\n')
fprintf('    =============================\n')
for i=1:numel(tests_)
    if tests_(i).Failed
        fprintf('     %-20s   X\n', tests_(i).Name)
    end
end
nok = sum(~[tests_.Failed]);
nfail = sum([tests_.Failed]);
fprintf('\nTotals: %d Passed, %d Failed\n', nok, nfail)

tests = tests_;
end

function fail = trytest(test)
try
    run(test)
    fail = false;
catch err
    fail = true;
end
end
