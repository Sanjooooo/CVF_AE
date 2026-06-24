function paperSceneId = cvfAePaperSceneId(codeSceneId)
%CVFAEPAPERSCENEID Map internal UAV scene IDs to paper scene numbers.
%
% Internal map ID 4 is presented as Scene 3 in all paper artifacts.

paperSceneId = codeSceneId;
paperSceneId(codeSceneId == 4) = 3;
end
