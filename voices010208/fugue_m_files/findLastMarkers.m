function [voices, nmat8, probRecords] = findLastMarkers(nmat8, ...
                lastMarker, noOfVoices, endPoint, HMMdata, probRecords)
% [voices, nmat8, probRecords] = findLastMarkers(nmat8, ...
%                lastMarker, noOfVoices, endPoint, HMMdata, probRecords)
%
% Using the HMM probabilities, allocate voices to the notes in the last 
% section: from the last marker, forwards, to the end


currentPoint = lastMarker;
while currentPoint < endPoint
    currentPoint = currentPoint + 1;   % Look at the next note in the nmat
    currentNote = nmat8(currentPoint, 4);  % Get the current pitch
    for i = 1:noOfVoices
        
        % Work out probability of this note being in voice i
        HMMprob = getHMMprob(nmat8, i, currentNote, currentPoint, lastMarker, cell2mat(HMMdata(i)));    
        
        prob(i, :) = [i HMMprob];  % Record this probability
    end
    
    % Allocate the note to a voice according to which voice has the highest
    % corresponding probability
    prob = sortrows(prob, -2);
    nmat8(currentPoint, 3) = prob(1,1);
    
    % For information purposes only: record the max probability value
    nmat8(currentPoint, 7) = prob(1,2);
    probRecords(currentPoint,:) = {prob};
end

voices = nmat8(:, 1:7);