function map = createMap(params)
%CREATEMAP Build 3D urban environments for different experimental scenes.
%
% sceneId:
%   1 - baseline urban corridor scene
%   2 - medium constrained corridor scene
%   4 - urban delivery corridor scene

if ~isfield(params, 'sceneId')
    sceneId = 1;
else
    sceneId = params.sceneId;
end

map.xlim = params.map.xlim;
map.ylim = params.map.ylim;
map.zlim = params.map.zlim;

switch sceneId
    case 1
        % ================================================================
        % Scene 1: Baseline urban corridor
        % ================================================================
        map.obstacles = [
            18 30 16 34  0 28;
            38 52 48 62  0 32;
            60 72 20 36  0 26;
            26 40 66 82  0 30;
            72 84 68 86  0 34;
            48 58 12 24  0 22
        ];

        map.nfz = [
            44 30  8  0 40;
            68 52 10  0 42;
            24 56  7  0 40
        ];

        map.windHotspots = [
            35 40 24 12 0.9;
            58 72 22 10 1.2;
            76 42 18 14 0.8
        ];

        map.baseWind = [2.5, 1.2, 0.0];

    case 2
        % ================================================================
        % Scene 2: Medium constrained corridor
        % This scene is intentionally between Scene 1 and Scene 4 in
        % difficulty: denser than the baseline urban scene, but not so tight
        % that reasonable algorithms are forced into high-altitude or
        % map-boundary bypasses.
        % ================================================================
        map.obstacles = [
            % lower block row: 4 buildings with wider gaps
            12 24 12 28  0 26;
            34 46 16 32  0 28;
            56 68 18 34  0 29;
            78 90 14 30  0 27;

            % middle row: keep pressure but leave a central corridor
            16 30 44 58  0 25;
            40 52 46 62  0 28;
            66 80 44 60  0 29;

            % upper row: avoid closing the goal-side passage
            14 28 72 86  0 26;
            42 56 70 86  0 29;
            72 86 72 88  0 27
        ];

        map.nfz = [
            31 40  5.5  0 34;
            63 58  6.0  0 34
        ];

        map.windHotspots = [
            30 36 18  9 1.0;
            52 55 18  8 1.1;
            74 74 16 10 0.9
        ];

        map.baseWind = [2.7, 1.3, 0.0];

    case 4
        % ================================================================
        % Scene 4: Urban delivery corridor (revised)
        % 更明显的主走廊 + 次级通道 + 少量卡口
        % ================================================================
    
        map.obstacles = [
            % =========================
            % Row 1 (bottom row)
            % 保留较规则街区，但适当拉开间距
            % =========================
            8  18  10 24  0 26;
            22 34  10 24  0 30;
            40 52  10 24  0 28;
            58 70  10 24  0 32;
            78 90  10 24  0 27;
        
            % =========================
            % Row 2
            % 中部开始形成“主通道 + 次通道”
            % 这里比之前明显放宽
            % =========================
            12 22  32 46  0 29;
            28 38  32 46  0 33;
            46 56  32 46  0 31;
            70 82  32 46  0 34;
        
            % =========================
            % Row 3
            % 刻意在中部留下更清晰主走廊
            % 保留左侧和右侧的候选次通道
            % =========================
            8  18  56 70  0 27;
            26 36  56 70  0 32;
            54 64  56 70  0 30;
            74 86  56 70  0 33;
        
            % =========================
            % Row 4 (top row)
            % 继续保持上部街区感，但避免压死终点附近通道
            % =========================
            12 26  78 92  0 26;
            32 46  78 92  0 29;
            54 68  78 92  0 31;
            76 88  78 92  0 28
        ];
    
        % 禁飞区放在关键路口和捷径通道口
        map.nfz = [
            42 27  5.5   0 42;
            66 50  6.0   0 42;
            26 73  5.5   0 42
        ];
    
        % 风热点布置在“看起来更短但风险更高”的局部区域
        map.windHotspots = [
            34 28 18  8  1.0;
            64 40 20  9  1.2;
            68 62 20 10  1.1;
            30 75 18  8  0.95;
            50 80 20  8  1.05
        ];
    
        map.baseWind = [2.9, 1.6, 0.0];

    otherwise
        error('Unsupported sceneId: %d. Use 1, 2, or 4.', sceneId);
end
end
