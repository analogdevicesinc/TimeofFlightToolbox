classdef BSPTests < matlab.unittest.TestCase
    
    properties
        IP = "192.168.86.53";
    end
    methods(TestClassSetup)
        function removeinstalledbsp(~)
            str = 'Analog Devices';
            ts = matlab.addons.toolbox.installedToolboxes;
            for t = ts
                if contains(t.Name,str)
                    disp('Removing installed BSP');
                    matlab.addons.toolbox.uninstallToolbox(t);
                end
            end
        end
        function changeRunLocation(~)
           testDir = fileparts(which(mfilename));
           out = strsplit(testDir,filesep);
           out = out(1:end-1);
           if isunix
               out = fullfile('/',out{:});
           else
               out = fullfile(out{:});
           end
           cd(out);
        end
        % Add the necessary files to path
%         function addbspfiles(~)
%             addpath(genpath('../hdl'));
%         end
    end
    
    methods(TestClassTeardown)
        function CleanupAdaptor(~)
            try
                imaqregister(adi.TOFAdaptor,'unregister');
            catch
            end
            imaqreset;
        end
    end
    
    methods (Test)
        
        function testRegister(~)
            imaqregister(adi.TOFAdaptor);
            imaqreset;
            imaqhwinfo
            imaqregister(adi.TOFAdaptor,'unregister');
            imaqreset;
        end
        
        function testVideoInputCall(testCase)
            imaqregister(adi.TOFAdaptor);
            imaqreset;
            imaqhwinfo
            % USB connection
%             videoinput('aditofadapter');
            % IP connection
            videoinput('aditofadapter', 1, testCase.IP);
            % Done
            imaqregister(adi.TOFAdaptor,'unregister');
            imaqreset;
        end
        
    end
    
end
