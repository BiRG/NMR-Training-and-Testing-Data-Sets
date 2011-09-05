function [converted_names] = SynonymConverter(molec_name, local_converter, synonyms)
% SynonymConverter: Reads an input of molecule names and converts them to names in the local database.
%--------------------------------------------------------------------------
%
% Input:
%       molec_name        List of molecule names.
%       local_converter   Location of list containing conversion between
%                         standard metabolite names and those in the local database.
%       synonyms          Location of synonym list.
%
% Output:
%       converted_names   List of the converted names. 
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

total = length(molec_name);   
inputname = molec_name;                                                          
[localname hmdbname] = textread(local_converter,'%s %s', 'delimiter', '\t','commentstyle','matlab');                                                                    
[commonname synonym] = textread(synonyms,'%q\t %q\t','commentstyle','matlab');  
                                                                                                                           
% CONVERT ALL TO LOWERCASE                                                                            .
InputName = lower(inputname); % Input molecule names                                          .
HMDBName = lower(hmdbname);  % HMDB common name.                                         
LocalName = lower(localname); % Local database name.                                         
CommonName = lower(commonname);% HMDB common name.                                           
Synonyms = lower(synonym);   % HMDB synonym.                                        

% Create cell array for output.                                                                
converted_names = cell(total,1);                                            
                               
for i = 1:total % For each molecule in the input.                                                            
    match1 = strmatch(InputName(i), LocalName, 'exact') ;    
    
    if match1 % If the name is in the local database...    
         %  put it in the output.
        if match1(1)
            converted_names(i) = localname(match1(1));
        else
            converted_names(i) = localname(match1);
        end;
    else % If the name is a HMDB common name...
        match2 = strmatch(InputName(i), HMDBName, 'exact');                                                                        
        if match2
            if match2(1) % if there are multiple versions just take the first.                                          
                converted_names(i) = localname(match2(1));    
                
            else % else put the corresponding local database name in the output.
                converted_names(i) = localname(match2);                   
            end
            
        else % If the name is a HMDB synonym...
            match3 = strmatch(InputName(i), Synonyms, 'exact');                                                                       
            if match3 
                match4 = strmatch(CommonName(match3(1,1)), HMDBName);
                
                % check if the HMDB common name has a corresponding local database name...                                                         
               if match4
                    if match4(1) % if there are multiple version, put the first in the output.
                        converted_names(i) = localname(match4(1));        
                        
                    else % else just put the one value in the output.
                        converted_names(i) = localname(match4);           
                        
                    end                                                     
                end
            end    
        end
    end
end


