function [sync_start, sync_type] = find_sync(signal, sync_half_duration, sync_duration)
    % Search for sync signals (syncC or syncD) in the oscillogram
    % sync_start - starting position of the sync signal
    % sync_type - type of sync signal ('C' or 'D')
    
    for i = 1:length(signal) - sync_duration + 1
        segment = signal(i:i + sync_duration - 1);
        
        % Split segment into two halves
        first_half = segment(1:sync_half_duration);
        second_half = segment(sync_half_duration + 1:end);
        
        % Check for syncC
        if all(first_half > 0.8) && all(second_half < -0.8)
            sync_start = i;
            sync_type = 'syncC';
            return;
        end
        
        % Check for syncD
        if all(first_half < -0.8) && all(second_half > 0.8)
            sync_start = i;
            sync_type = 'syncD';
            return;
        end
    end
    
    % If sync signal is not found
    sync_start = [];
    sync_type = 'None';
end