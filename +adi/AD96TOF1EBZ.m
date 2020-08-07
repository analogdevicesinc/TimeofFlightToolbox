classdef AD96TOF1EBZ < matlab.System
    % AD96TOF1EBZ 3D Time of Flight Development Platform
    %
    % The ADI ToF system uses a VGA CCD that enables the user to capture a
    % 640x480 depth map of an image, providing up to 4x higher resolution
    % than many other TOF systems on the market. This enables users to
    % detect and measure the distance to smaller and thinner objects that
    % would otherwise be invisible to other ToF systems.
    
    properties
        % Connection Connection
        %   Interface used to talk to the development board. Options are:
        %   - IP
        %   - USB
        Connection = 'IP';
        % IPAddress IP Address
        %   IP Address of development board. This is only
        %   applicable when Connection is set to 'IP'.
        IPAddress = '192.168.2.1';
        % FrameType Frame Type
        %   Camera frame source selection. Options are:
        %   - Depth
        %   - Ir
        FrameType = 'Depth';
        % CameraMode Camera Mode
        %   Camera distance mode. Options are:
        %   - Near
        %   - Medium
        %   - Far
        CameraMode = 'Near';
    end
    
    properties (Logical, Nontunable)
        % EnableVideo Enable Video
        %   Start video streams when initializing device
        EnableVideo = false;
    end
    
    % Pre-computed constants
    properties(Access = private)
        % Video input object
        vid;
        % Source devices
        src;
        ConnectedToDevice = false;
    end
    
    properties(Constant, Hidden)
        ConnectionSet = matlab.system.StringSet({ ...
            'IP','USB'});
        FrameTypeSet = matlab.system.StringSet({ ...
            'Depth','Ir'});
        CameraModeSet = matlab.system.StringSet({ ...
            'Near','Medium','Far'});
    end
    
    methods
        %% Constructor
        function obj = AD96TOF1EBZ(varargin)
            % Load the library if necessary
            warning('off','imaq:imaqhwinfo:additionalVendors');
            if ~obj.FindAdaptor()
                imaqregister(adi.TOFAdaptor());
            end
            warning('on','imaq:imaqhwinfo:additionalVendors');
            assert(obj.FindAdaptor(),'aditofadaptor not found');
        end
        % Check FrameType
        function set.FrameType(obj, value)
            obj.FrameType = value;
            if obj.ConnectedToDevice %#ok<*MCSUP>
                obj.src.FrameType = value;
            end
        end
        % Check FrameType
        function set.CameraMode(obj, value)
            obj.CameraMode = value;
            if obj.ConnectedToDevice
                obj.src.CameraMode = value;
            end
        end
        
        function imshow(obj)
            imshow(obj.step());
        end
        
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            switch obj.Connection
                case 'IP'
                    obj.vid = videoinput('aditofadapter', 1, obj.IPAddress);
                case 'USB'
                    obj.vid = videoinput('aditofadapter', 1);
                otherwise
                    error('Unknown connection type');
            end
            % Set properties
            obj.src = getselectedsource(obj.vid);
            obj.src.FrameType = obj.FrameType;
            obj.src.CameraMode = obj.CameraMode;
            obj.ConnectedToDevice = true;
            if obj.EnableVideo
                start(obj.vid);
            end
        end
        
        function depthMap = stepImpl(obj)
            depthMap = getsnapshot(obj.vid);
        end
        
        function releaseImpl(obj)
            % Release resources, such as file handles
            if obj.EnableVideo
                stop(obj.vid);
            end
            obj.src = [];
            obj.vid = [];
            obj.ConnectedToDevice = false;
            imaqregister(adi.TOFAdaptor(),'unregister');
        end
    end
    
    methods(Static)
        function found = FindAdaptor()
            imaqreset;
            info = imaqhwinfo;
            found = 0;
            for k = 1:length(info.InstalledAdaptors)
                found = found || strcmpi(info.InstalledAdaptors{k},'aditofadapter');
            end
        end
    end
end
