Algorithms={'01' '02' '04','05','06','07','10','12','14','16'};
%HistSteps=[5];

load('RandomSamplingStatistics.mat');
InputRoot='/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/';


for AlgInd=1:length(Algorithms)
    Algorithm=Algorithms{AlgInd};
    %HistStep=HistSteps(AlgInd);
    
    %if ~isfield(Statistics,['A' Algorithm]) || ~isfield(Statistics.(['A' Algorithm]),'List')
    Statistics.(['A' Algorithm]).List=getAllFiles([InputRoot Algorithm],'*.mat',true);
    %end
    
    if AlgInd>2
        RandomizedIndex=randperm(length(Statistics.(['A' Algorithm]).List));
        for File=[]% 1:10000 %length(RandomizedIndex)
            FileInd=RandomizedIndex(File);
            L=load(Statistics.(['A' Algorithm]).List{FileInd});
            Map=GetAlgorithmInputMap(L,Algorithm);
            for ii=1:length(Map)
                LocalMax=max(max(Map{ii}));
                LocalMin=min(min(Map{ii}));
                LocalMaxNoInf=max(max(Map{ii}(Map{ii}~=Inf)));
                LocalMinNoInf=min(min(Map{ii}(Map{ii}~=-Inf)));
                
                if ~isfield(Statistics.(['A' Algorithm]),'Max') || length(Statistics.(['A' Algorithm]).Max)<ii || Statistics.(['A' Algorithm]).Max{ii}<LocalMax
                    Statistics.(['A' Algorithm]).Max{ii}=LocalMax;
                end
                if ~isfield(Statistics.(['A' Algorithm]),'Min') || length(Statistics.(['A' Algorithm]).Min)<ii || Statistics.(['A' Algorithm]).Min{ii}>LocalMin
                    Statistics.(['A' Algorithm]).Min{ii}=LocalMin;
                end
                if ~isfield(Statistics.(['A' Algorithm]),'MaxNoInf') || length(Statistics.(['A' Algorithm]).MaxNoInf)<ii || Statistics.(['A' Algorithm]).MaxNoInf{ii}<LocalMax
                    Statistics.(['A' Algorithm]).MaxNoInf{ii}=LocalMaxNoInf;
                end
                if ~isfield(Statistics.(['A' Algorithm]),'MinNoInf') || length(Statistics.(['A' Algorithm]).MinNoInf)<ii || Statistics.(['A' Algorithm]).MinNoInf{ii}>LocalMin
                    Statistics.(['A' Algorithm]).MinNoInf{ii}=LocalMinNoInf;
                end
            end
        end
    end
    
    save('RandomSamplingStatistics_2.mat','Statistics');
end