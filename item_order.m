classdef item_order
    properties
        name%obligatory
        create_date%obligatory
        inputs%obligatory
        outputs%obligatory
        creator%obligatory
        Results%obligatory
    end
    
    methods

        function T=item_order()%obligatory
            %object constructor
            T.name = 'Item order - pořadí objektů';
            T.inputs = {'aa','bb'};
            T.outputs = {};
            T.create_date='2014-11-05';%obligatory
            T.creator='Ondrej Janata <janaton1@fel.cvut.cz>';
            load('Tasks/item_order/conconats.txt');
            
        end
        
        function T=run(T,inputs)%obligatory
            %main function which describes 1 run(trial) of the task ...
            based on the input parameters
        end
        
        function T=results(T,time,gcf,j)%obligatory
            T.Results(j).time=time
            T.Results(j).correctness%numerical value from 0−1 which describes the quality of the answer
            %in results you can save any further information important to be saved for the task
            T.Results(j).any_further_information 
        end
        
        function datTask=Random(T,nmbRep)%obligatory
            % generates table with nmbRep rows and nmbInputPar ...
            % columns with automatically generated parameters of ...
            % trials (nmbRep is number of trials)
            for i=1:nmbRep
                %datTask(i,1)=
            end
        end
        
        function datTask=Manual(T,nmbRep)%obligatory
        end
        
        function datTask=SemiRandom(T,nmbRep)%obligatory
        end
        
        function tasks_m=menu(T,tasks_m)%obligatory
            %can be empty
            %if any additional submenu with function is required ...
            %than it can be defined here as follows:

            Task name m=uimenu(tasks_m,'Label','Task_name')
            %main folder for task submenus with additional information
            uimenu(task_name_m,'Label','submenu_name','callback',@callback_name)
            %submenu definition
            %which will redirect you to function callback name ...
            %(which must be defined in this file below)
        end
    end
    
end
