%% %%%%%
% Author: Ondrej Janata <janaton1@fel.cvut.cz>
%
% Homepage: https://github.com/hack006/item_order
% Documentation: https://github.com/hack006/item_order/README.md
% License: GPLv3 (http://www.gnu.org/licenses/gpl-3.0.txt)
% %%%%%%
classdef item_order
    properties
        %% Properties
        
        name%obligatory
        create_date%obligatory
        inputs%obligatory
        outputs%obligatory
        creator%obligatory
        Results%obligatory
        
        % All possible characters
        character_set
        
        % Vector of serie data setups
        %  serie struct fields
        %   * shown_to_memorize
        %   * shown_to_match
        %   * type
        %       * 0 - same
        %       * 1 - position swap
        %       * 2 - character change
        %   * change_position
        TrialDataSetups
        
        % time for which character sequence is visible to user
        memorize_time
        
        %  time for which blank screen is visible between memorizing and
        % reasoning if string is same or different
        delay_time
        
        % Percentage of trials where characters are swapped
        character_swap_percentage
        
        % Percenatge of trials where character is changed
        character_change_percentage
        
        % Vector of percentage of change changes on string position
        character_position_change_percentage
        
        % Store current trial type for transmitting type between run and
        % result function
        current_trial_type
        
        current_position_change
        
    end
    
    methods
        %% %%%%%
        % @OBLIGATORY
        % Class constructor
        % %%%%%%
        function T=item_order()
            T.name = 'Item order - pořadí objektů';
            T.inputs = {'string_to_memorize', 'string_to_match','change_type','change_position'};
            T.outputs = {'type','change_position','answer_key'};
            T.create_date='2014-11-05';
            T.creator='Ondrej Janata <janaton1@fel.cvut.cz>';
            
            T.character_set = 'BCDFGHJKLMNPQRSTVWXYZ';
            T.character_swap_percentage = 30; % TODO make configurable
            T.character_change_percentage = 30; % TODO make configurable
            T.character_position_change_percentage = [0.1, 0.15, 0.5, 0.25, 0.20, 0.15];
            
            T.current_trial_type = 0;
            % currently hard set up
            % TODO in the future maybe make configurable
            T.memorize_time = 5.0;
            T.delay_time = 2.0;
        end
        
        %% %%%%%
        % @OBLIGATORY
        function T=run(T,varargin)%obligatory
            % %%%%
            % WORKAROUND - direct passing of arguments failed
            % %%%%
            string_to_memorize = varargin{1,1};
            string_to_match = varargin{1,2};
            tmp = varargin{1,3};
            change_type = tmp{1};
            tmp = varargin{1,4};
            change_position = tmp{1};
            % store current trial type - used in result function
            T.current_trial_type = change_type;
            T.current_position_change = change_position;
            
            % %%%%
            % SHOW BEFORE TRIAL EXPERIMENT TEXT
            % %%%%
            instructions_text_bg = uicontrol('units','normalized',...
                'style','text',...
                'FontSize',16,...
                'position',[0.05 0.85 0.9 0.1],'string','');
            instructions_text = uicontrol('units','normalized',...
                'style','text',...
                'FontSize',16,...
                'position',[0.05 0.80 0.9 0.1],'string','Press any key to start next trial.');
            test_string_bg = uicontrol('units','normalized',...
                'style','text',...
                'FontSize',44,...
                'position',[0.15 0.4 0.7 0.2],'BackgroundColor','black',...
                'ForegroundColor','white','string','');
            test_string_label = uicontrol('units','normalized',...
                'style','text',...
                'FontSize',44,...
                'position',[0.15 0.45 0.7 0.1],...
                'BackgroundColor','black',...
                'ForegroundColor','white',...
                'FontName', 'Monospaced',...
                'string','-------');
            
            waitforbuttonpress;
            % %%%%
            % Wait some time to memorize
            % %%%%
            set(instructions_text, 'string', 'Remember string');
            set(test_string_label, 'string', string_to_memorize);
            pause(T.memorize_time);
            
            % %%%%
            % Hide all text for some time
            % %%%%
            %set(instructions_text, 'string', '')
            set(test_string_label, 'string', '???????');
            pause(T.delay_time);
            
            % %%%%
            % SHOW TEXT FOR COMPARISON
            % %%%%
            tic; % start time measurement
            set(instructions_text, 'string', 'Same strings - "L"         Different strings - "A"');
            set(test_string_label, 'string', string_to_match);
        end
        
        %% %%%%%
        % @OBLIGATORY
        function T=result(T,time,gcf,j)%obligatory
            response_key = get(gcf,'CurrentCharacter');%last key pressed
            
            % %%%%
            % TODO - 
            % %%%%
            if response_key == 'l' || response_key == 'L'
                % test type of trial - only {0} marks no change
                if T.current_trial_type == 0
                    answer = 1;
                else
                    answer = 0;
                end

            elseif response_key == 'a' || response_key == 'A'
                % test type of trial - only {1,2} marks change
                if T.current_trial_type == 1 || T.current_trial_type == 2
                    answer = 1;
                else
                    answer = 0;
                end
            else
                % if bad key press mark as wrong answer
                answer = 0;
            end
            
            
            T.Results.time(j) = time
            T.Results.correctness(j) = answer %numerical value from 0−1 which describes the quality of the answer
            %in results you can save any further information important to be saved for the task
            T.Results.type(j) = T.current_trial_type
            T.Results.change_position(j) = T.current_position_change
            T.Results.answer_key(j) = response_key
        end
        
        % %%%%%%
        % @OBLIGATORY
        % Random generation of task trials data 
        %
        % Routine which is called by Psycheeg to retreive random generated
        % trials data for experiment.
        %
        % @param T [item_order] - instance of class
        % @param nmbRep [int] - number of trials entered in dialog
        % @return [cellarray] - formated array of computed setups of trials
        %   - datTask(i,j)
        %       - i = row index
        %       - j = column index
        % %%%%%%
        function datTask=Random(T,nmbRep)%obligatory
            %% %%%
            % 0)
            % General setup
            % %%%%
            
            % general setup - set trials type counts
            T.general_experiment_setup(nmbRep);
            GES = ans
            
            %% %%%
            % 1.1)
            % Generate array of types of trials
            % %%%%
            
            CHARACTER_POSITION_CHANGE_ARR = linspace(-1,-1,GES.character_change_count);
            CHARACTER_POSITION_SWAP_ARR = linspace(-1,-1,GES.character_swap_count);
            
            % generate trial type order
            trials_type_order_source = [linspace(0,0,GES.character_not_touched_count) ...
                linspace(1,1,GES.character_swap_count) ...
                linspace(2,2,GES.character_change_count)];
            trials_type_order = trials_type_order_source;
            
            % randomize order
            pos = 1;
            random_order = randperm(nmbRep)
            for i=random_order
                trials_type_order(pos) = trials_type_order_source(i);
                pos = pos + 1;
            end
            
            %% %%%
            % 1.2) 
            % Generate change array
            %
            % With respect to procents of character position changes generate 
            % character swap counts for positions from 1 to 6
            %
            % positon 1 means that first and second chars are swapped
            % %%%%
            percentage_for_one_trial = 1.0 / GES.character_swap_count;
            division_remainder = 0.0;
            char_position_change_count = 0;
            
            %{'string_to_memorize', 'string_to_match','change_type','change_position'};
            for i=1:5
                % append position to CHARACTER_POSITION_CHANGE_ARR
                tmp = find(CHARACTER_POSITION_CHANGE_ARR < 0);
                
                if isempty(tmp)
                    break
                end
                
                char_position_change_count = (T.character_position_change_percentage(i) / percentage_for_one_trial);
                char_position_change_count = char_position_change_count + division_remainder; % add remainder from previous
                
                
                CHARACTER_POSITION_CHANGE_ARR(tmp(1):floor(tmp(1)+char_position_change_count-1)) = linspace(i,i,floor(char_position_change_count));
                
                % update remainder
                division_remainder = mod(char_position_change_count, 1);
                
            end
            % last trial count is calculated to match change count trials
            
            for i=(sum(CHARACTER_POSITION_CHANGE_ARR~=-1)+1):GES.character_change_count
                CHARACTER_POSITION_CHANGE_ARR(i) = 6;
            end
            
            
            %% %%%%
            % 1.3) 
            % Generate swap array
            % 
            % With respect to procents of character position changes generate 
            % character swap counts for positions from 1 to 6
            %
            % positon 1 means that first and second chars are swapped
            % %%%%
            
            percentage_for_one_trial = 1.0 / GES.character_swap_count;
            division_remainder = 0.0;
            char_position_swap_count = 0;
            
            for i=1:5
                % append position to CHARACTER_POSITION_CHANGE_ARR
                tmp = find(CHARACTER_POSITION_SWAP_ARR < 0);
                
                if isempty(tmp)
                    break;
                end                
                
                char_position_swap_count = (T.character_position_change_percentage(i) / percentage_for_one_trial);
                char_position_swap_count = char_position_swap_count + division_remainder; % add remainder from previous
                
                CHARACTER_POSITION_SWAP_ARR(tmp(1):floor(tmp(1)+char_position_swap_count-1)) = linspace(i,i,floor(char_position_swap_count));
                
                % update remainder
                division_remainder = mod(char_position_swap_count, 1);
            end
            % last trial count is calculated to match swap count trials
            for i=(sum(CHARACTER_POSITION_SWAP_ARR~=-1)+1):GES.character_swap_count
                CHARACTER_POSITION_SWAP_ARR(i) = 6;
            end
            
            %% %%%
            % 2) 
            % Format output
            %
            % generates table with nmbRep rows and nmbInputPar ...
            % columns with automatically generated parameters of ...
            % trials (nmbRep is number of trials)
            % %%%%
            change_counter = 1;
            swap_counter = 1;
            for i=1:nmbRep
                pchp = randperm(size(T.character_set,2));
                % characters which are shown
                shown_string = sprintf('%c%c%c%c%c%c%c', T.character_set(pchp(1)), ...
                    T.character_set(pchp(2)),T.character_set(pchp(3)), ...
                    T.character_set(pchp(4)), T.character_set(pchp(5)), ...
                    T.character_set(pchp(6)), T.character_set(pchp(7)));
                % %%%%%%%
                % DECIDE TYPE OF TRIAL
                %   0 - no change
                %   1 - char swap
                %   2 - char change
                % %%%%%%%
                switch trials_type_order(i)                        
                    case 1
                        % SWAP CHARS on the (i)-th and (i+1)-th postions
                        swapped_string = shown_string;
                        change_position = CHARACTER_POSITION_SWAP_ARR(swap_counter);
                        swapped_string(change_position) = shown_string(change_position + 1); 
                        swapped_string(change_position + 1) = shown_string(change_position); 
                        
                        datTask(i,1:4) = {shown_string, swapped_string, 1, change_position};
                        swap_counter = swap_counter + 1;
                    case 2
                        % CHANGE CHAR on the i-th position
                        swapped_string = shown_string;
                        change_position = CHARACTER_POSITION_SWAP_ARR(change_counter);
                        not_used_chars = setdiff(T.character_set, shown_string);
                        replacement_char = not_used_chars(randi(size(not_used_chars,2),1,1));
                        swapped_string(change_position) = replacement_char;
                        
                        datTask(i,1:4) = {shown_string, swapped_string, 2, change_position};
                        change_counter = change_counter + 1;
                    otherwise
                        datTask(i,1:4) = {shown_string, shown_string, 0, 0};
                end
                
            end
        end
        %% %%%%%
        % @OBLIGATORY
        % Probably old name of routine to generate trial data manually
        % %%%%%%
        function datTask = Manual(T,nmbRep)        
            datTask=T.Manually_edit(nmbRep); 
        end
            
        %% %%%%%
        % @OBLIGATORY
        % Manual generation of task trials data 
        %
        % Routine which is called by Psycheeg to retreive manually generated
        % trials data for experiment.
        % New dialog for data entering si shown.
        %
        % @param T [item_order] - instance of class
        % @param nmbRep [int] - number of trials entered in dialog
        % @return [cellarray] - formated array of computed setups of trials
        %   - datTask(i,j)
        %       - i = row index
        %       - j = column index
        % %%%%%%
         function datTask = Manually_edit(T,nmbRep)  %obligatory
            %% %%%%%
            % Create dialog
            % %%%%%%
            manualDialog = figure('Name','Manual task setup generator','Units','pixels','Position',[10 10 1000 700],'MenuBar', 'none','Color','white');
            
            uicontrol(manualDialog,'Units','normalized',...
                'Style','text',...
                'Position',[0.05 0.8 0.9 0.1],...
                'BackgroundColor','black',...
                'String','');
            uicontrol(manualDialog,'Units','normalized',...
                'Style','text',...
                'Position',[0.05 0.72 0.9 0.08],...
                'ForegroundColor','white',...
                'BackgroundColor','black',...
                'String','Manual task setup generator. Configure values and press SAVE.',...
                'FontSize',18);
            
            %% %%%%%
            %  Basic setup of dialog
            % %%%%%%
            data_types=cell(3, 2);
            
            data_types{1} = {'same',0};
            data_types{2} = {'position swap',1};
            data_types{3} = {'position change',2};
           
            dataCellArray = cell(nmbRep,4);
            
            for i=1:nmbRep
                dataCellArray(i,1) = {''};
                dataCellArray(i,2) = {''};
                dataCellArray(i,3) = {'same'};
                dataCellArray(i,4) = {0};
                dataCellArray(i,5) = {''};
                dataCellArray(i,6) = {false};
                dataCellArray(i,7) = {'fill data'};
            end;
                   
            % Draw table
            manualConfigTable = uitable(manualDialog,'Data',dataCellArray,...
                'units','normalized',...
                'position',[0.05 0.1 0.9 0.6],...
                'ColumnName', {'Memorize string','Decision string', 'Type of trial', 'Position change', 'Change character', 'Trial syntax ok?', 'Error message'},...
                'ColumnFormat',{'char','char',{'same' 'position swap' 'position change'},'numeric','char','logical', 'char'},...
                'ColumnEditable',[true false true true true false false],...
                'CellEditCallback', @T.manualTableChangedValidationCallback);
            
            % Draw control buttons
            save_btn = uicontrol(manualDialog,'units','normalized',...
                'style','pushbutton',...
                'string','SAVE',...
                'FontSize', 8,...
                'HorizontalAlignment',...
                'left','position',[0.8 0.02 0.15 0.05],...
                'callback',{@T.manualDataSAVECallback,manualConfigTable});
        
            waitfor(save_btn);
            
            % Pass entered datasets
            dataCellArray = get(manualConfigTable,'Data');
            for i=1:nmbRep
                datTask(i,1) = dataCellArray(i,1); % shown string
                datTask(i,2) = dataCellArray(i,2); % compare to string
                trial_type_int_val = 0;
                switch dataCellArray{i,3}
                    case 'position swap'
                        trial_type_int_val = 1;
                    case 'position change'
                        trial_type_int_val = 2;
                    otherwise
                        trial_type_int_val = 0;
                end
                datTask(i,3) = {trial_type_int_val}; % change type
                datTask(i,4) = dataCellArray(i,4); % position change
            end
            delete(manualDialog);
         end
        
         %% %%%%
         % Callback for change in table in manual setup dialog
         %
         % Used for generation of decision string and for validation
         % of entered data
         %
         % @param T [item_order] - instance of experiment
         % @param hObject [handle] - handle to table
         % @param eventData [struct] - data of changed cell
         %      - coordinates
         %      - old_text, nex_text, ..
         % %%%%
         function manualTableChangedValidationCallback(T,hObject,eventData)
           
            currentTableData = get(hObject, 'Data');
            selectedRowNum = eventData.Indices(1);
            selectedRow = currentTableData(selectedRowNum,:);
            
            
            %% %%%%
            % LOAD PARAMS
            % %%%%%
            memorize_string = selectedRow{1}
            decision_string = selectedRow{2}
            trial_type_txt = selectedRow{3}
            switch trial_type_txt
                case 'position swap'
                    trial_type=1;
                case 'position change'
                    trial_type=2;
                otherwise
                    trial_type=0;
            end;        
            position_change = selectedRow{4}
            new_char = selectedRow{5}
            
            %% %%%%
            % TEST if input valid
            % %%%%%
            trial_setup_correct = false;
            err_msg = '';
            if trial_type == 0
                % lengt must be greater or equal 7
                if size(memorize_string,2) >= 7
                    trial_setup_correct = true;
                    err_msg = '';
                else
                    err_msg = 'string must be 7 chars long';
                end
            elseif trial_type == 1 || trial_type == 2
                % lengt must be greater or equal 7
                if size(memorize_string,2) < 7
                    trial_setup_correct = false;
                    err_msg = 'string must be 7 chars long'
                % position change must be in range 1:6
                elseif position_change < 1 || position_change > 6 
                    err_msg = 'change position must be in range {1,..,6}';
                elseif trial_type == 2 && size(new_char,2) < 1
                    err_msg = 'enter character for change'
                else
                    trial_setup_correct = true;
                    err_msg = '';
                end
            else
                trial_setup_correct = false;
            end;
            

            % @todo
            
            %% %%%%%
            % FORMAT OUTPUT
            %
            % %%%%%%
            % cut if text longer then 7 chars 
            if size(memorize_string,2) > 7
                memorize_string = memorize_string(1:7);
            end
            memorize_string = upper(memorize_string);
            currentTableData(selectedRowNum,1) = {memorize_string};
            set(hObject,'Data',currentTableData);
            
            if trial_setup_correct == true
                switch trial_type
                    case 0
                        decision_string = memorize_string;
                    case 1
                        %swap positions
                        if position_change > 0 && position_change < 7
                            decision_string = [...
                                memorize_string(1:(position_change-1))...
                                memorize_string(position_change + 1)...
                                memorize_string(position_change)...
                                memorize_string((position_change + 2):end)
                            ];
                        else
                            memorize_string = '';
                        end
                    case 2
                        new_char = new_char(1);
                        %change position
                        if position_change > 0 && position_change < 7
                            decision_string = [...
                                memorize_string(1:(position_change-1))...
                                new_char...
                                memorize_string((position_change + 1):end)
                            ];
                        else
                            memorize_string = '';
                        end
                    otherwise
                        trial_type_exception = MException('table:invalid_trial_type',...
                            'Trial type can be only in range 0..2!!');
                        raise(trial_type_exception);
                end
            end;
            
            % update table
            currentTableData(selectedRowNum,2) = {decision_string};
            currentTableData(selectedRowNum,6) = {trial_setup_correct};
            currentTableData(selectedRowNum,7) = {err_msg};
            set(hObject,'Data',currentTableData);
               
         end
        
        %%
        % Manual trial data setup dialog - save button callback
        %
        % Ensures correct settings of trials
        %
        function manualDataSAVECallback(T,hObject,eventData,hTable)
            tableData = get(hTable,'Data');
            all_data_correct = true;
            % Check all rows of table if trial is entered correctly
            for i=1:size(tableData,1)
                if tableData{i,6} == false
                    all_data_correct = false;
                end
            end;
            
            if all_data_correct
                delete(hObject)
            else
                h = warndlg('Not all trials are entered correctly! Please, correct it.');
            end
        end
        
        %% %%%%%
        % @OBLIGATORY
        % Old Routine for semirandom data trial generatin
        % 
        % Calling new routine Partly_random()
        %
        % %%%%%%
        function datTask=SemiRandom(T,nmbRep)
            datTask=T.Partly_random(nmbRep);
        end
        
        %% %%%%%
        % @OBLIGATORY
        % Old Routine for semirandom data trial generatin
        % 
        % @todo implement
        % %%%%%%
        function datTask = Partly_random(T,nmbRep)  
            partlyRandomDialog = figure('Name','Warning! Partly random generation not supported, yet.',...
                'Units','pixels',...
                'Position',[10 10 320 240],...
                'MenuBar', 'none',...
                'Color',[0.98 0.72 0.72]);
            
            uicontrol(partlyRandomDialog,'Units','normalized',...
                'Style','text',...
                'Position',[0.05 0.5 0.9 0.4],...
                'BackgroundColor','red',...
                'String','');
            uicontrol(partlyRandomDialog,'Units','normalized',...
                'Style','text',...
                'Position',[0.1 0.54 0.8 0.34],...
                'ForegroundColor','white',...
                'BackgroundColor','red',...
                'String','Partly manual generator is not currently implemented. Switching to manual one ...',...
                'FontSize',14);
            ok = uicontrol(partlyRandomDialog,'Units','normalized',...
                'Style','pushbutton',...
                'Position',[0.6 0.1 0.35 0.1],...
                'String','Ok',...
                'Callback',@T.partlyRandomOkCallback);
            
            waitfor(ok); % wait for accepting dialog
            
            delete(partlyRandomDialog);
            datTask = T.Manually_edit(nmbRep);
        end
        
        %% %%%%%
        % Callback called before closing partly random dialog
        %
        % %%%%%%
        function partlyRandomOkCallback(T,hObject,event)
            % do nothing
            delete(hObject);
        end
        
        %% %%%%%
        % SUPPORT FUNCTIONS
        %
        % Functions which are used across methods of this class
        % %%%%%%
            %% %%%%%
            % Check if changed char count and swap count is not larger than
            % trials count
            % %%%%%
            function check_input_count_correctness(count,swap_count,change_count)
                if count < (swap_count + change_count)
                    % TODO let know that wrong value entered
                end
            end

            % %%%%
            % Calculate necessary global values for experiment setup
            %   
            % @param T [item_order] - reference to instance of this class
            % @param nmbRep [int] - number of trials in experiment
            % @return [struct]
            %   * character_swap_count [int] - count of trials where
            %       swapping characters in string
            %   * character_change_count [int] - count of trials where
            %       changing character in string
            %   * character_not_touched_count [int] - count of trials
            %       without change
            % %%%%
            function GES=general_experiment_setup(T,nmbRep)
                GES.character_swap_count = round((T.character_swap_percentage / 100) * nmbRep);
                GES.character_change_count = round((T.character_change_percentage / 100) * nmbRep);
                GES.character_not_touched_count = nmbRep - GES.character_swap_count - GES.character_change_count;
            end
        
        %% %%%%%
        % @OBLIGATORY
        % Experiment menu create callback
        %
        % Creates only simple entry in menu - for later usage :)
        %
        % @param T [item_order] - class instance
        % @param tasks_m [handle] - handle to main tasks menu
        % %%%%%%
        function tasks_m=menu(T,tasks_m)%obligatory
            m=uimenu(tasks_m,'Label','Item order');
        end
    end
    
end
