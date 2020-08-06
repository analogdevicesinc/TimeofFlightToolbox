function dllpath = TOFAdaptor()

if ispc
    dllpath = fullfile(fileparts(strtok(mfilename('fullpath'), '+')),'deps','aditofadapter.dll');
else
    dllpath = fullfile(fileparts(strtok(mfilename('fullpath'), '+')),'deps','aditofadapter.so');
end

end

