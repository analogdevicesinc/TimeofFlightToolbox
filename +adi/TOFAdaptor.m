function dllpath = TOFAdaptor()

    dllpath = fullfile(fileparts(strtok(mfilename('fullpath'), '+')),'deps','aditofadapter.so');

end

