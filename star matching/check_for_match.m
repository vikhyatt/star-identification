%Takes in a candidate triangle as input and identifies the stars in the
%triangle using status method
function [identification,star_id_i,star_id_j,star_id_k] = check_for_match(triangles,iterator,number,epsilon,sm_GSC,sm_PSC,number_of_stars,starter)
i = triangles(iterator,1);
j = triangles(iterator,2);
k = triangles(iterator,3);
d_i_j = triangles(iterator,5);
d_i_k = triangles(iterator,6);
d_j_k = triangles(iterator,7);

status = zeros(number_of_stars,1);

block_i_j = ceil((d_i_j-starter)/epsilon)-1;
block_i_k = ceil((d_i_k-starter)/epsilon)-1;
block_j_k = ceil((d_j_k-starter)/epsilon)-1;

i_j_candidates = sm_PSC((table2array(sm_PSC(:,end))>=((block_i_j*epsilon)+starter)) & (table2array(sm_PSC(:,end))<((block_i_j+1)*epsilon)+starter),:);

i_k_candidates = sm_PSC((table2array(sm_PSC(:,end))>=((block_i_k*epsilon)+starter)) & (table2array(sm_PSC(:,end))<((block_i_k+1)*epsilon)+starter),:);

j_k_candidates = sm_PSC((table2array(sm_PSC(:,end))>=((block_j_k*epsilon)+starter)) & (table2array(sm_PSC(:,end))<((block_j_k+1)*epsilon)+starter),:);


x = size(i_j_candidates);
y = size(i_k_candidates);
z = size(j_k_candidates);



for element = 1:x(1)
    status(table2array(i_j_candidates(element,1)),1) = status(table2array(i_j_candidates(element,1)),1)+1;
end

i_j_level_1 = i_j_candidates(:,1:2);
i_k_level_2 = zeros(y(1),2);

for element = 1:y(1)
    if status(table2array(i_k_candidates(element,1)),1)==1
        temp_1 = table2array(i_k_candidates(element,1));
        temp_2 = table2array(i_k_candidates(element,2));
        i_k_level_2(element,:) = [double(temp_1),double(temp_2)];
        status(table2array(i_k_candidates(element,1)),1) = status(table2array(i_k_candidates(element,1)),1)+1;
    end
end  

i_k_level_2 = i_k_level_2(i_k_level_2(:,1) >0,:);

xyz = size(i_j_level_1);
i_j_level_2 = zeros(xyz(1),2);

for element = 1:xyz(1)
    if status(table2array(i_j_level_1(element,1)),1) == 2
        temp_1 = table2array(i_j_level_1(element,1));
        temp_2 = table2array(i_j_level_1(element,2));
        i_j_level_2(element,:) = [double(temp_1),double(temp_2)];
        status(table2array(i_j_level_1(element,1)),1) = 3;
    end
end 

i_j_level_2 = i_j_level_2(2,:);
i_j_level_2 = sortrows(i_j_level_2,1);
i_k_level_2 = sortrows(i_k_level_2,1);
counter = 0;

last_size = size(i_j_level_2);
for iterate = 1:last_size(1)
    for element = 1:z(1)
        if i_j_level_2(iterate,2)==table2array(j_k_candidates(element,1)) && i_k_level_2(iterate,2)==table2array(j_k_candidates(element,2));
            star_id_i = i_j_level_2(iterate,1)
            star_id_j = i_j_level_2(iterate,2)
            star_id_k = i_k_level_2(iterate,2)
            counter = counter+1;
            break
        end
    end
end  

if counter==1
    
    identification = 1;
else 
    star_id_i = 0;
    star_id_j = 0;
    star_id_k = 0;
    identification = 0;
end

end 

