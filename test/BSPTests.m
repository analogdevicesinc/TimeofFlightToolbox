classdef BSPTests < matlab.unittest.TestCase
    
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
        % Add the necessary files to path
        function addbspfiles(~)
            addpath(genpath('../hdl'));
        end
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
        
        function testVideoInputCall(~)
            imaqregister(adi.TOFAdaptor);
            imaqreset;
            imaqhwinfo
            % USB connection
            videoinput('aditofadapter');
            % Done
            imaqregister(adi.TOFAdaptor,'unregister');
            imaqreset;
        end
        
    end
    
end
