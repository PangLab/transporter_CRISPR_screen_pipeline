args = commandArgs(trailingOnly=TRUE)

library(MAGeCKFlute)
library(ggplot2)

file1 = file.path(args[1])
file2 = file.path(args[2])

# Read and visualize the file format
gdata = ReadRRA(file1)
sdata = ReadsgRRA(file2)
Neg_ctrl <- grep('NonTargeting_Human_', as.vector(as.data.frame(sdata)[,2]), value=TRUE)

pdf(args[3], height = 9, width = 12)
# not remove essential genes
depmap_similarity = ResembleDepmap(gdata, symbol = "id", score = "Score")
gdata$LogFDR = -log10(gdata$FDR)
p2 = VolcanoView(gdata, x = "Score", y = "FDR", Label = "id", top = 10)
print(p2)
gdata$Rank = rank(gdata$Score)
p1 = ScatterView(gdata, x = "Rank", y = "Score", label = "id", 
                 top = 10, auto_cut_y = TRUE, ylab = "Log2FC", 
                 groups = c("top", "bottom"))
print(p1)
# Dot plot
gdata$RandomIndex = sample(1:nrow(gdata), nrow(gdata))
gdata = gdata[order(-gdata$Score), ]
# Visualize positive selected genes.
gg = gdata[gdata$Score>0, ]
p1 = ScatterView(gg, x = "RandomIndex", y = "Score", label = "id",
                 y_cut = CutoffCalling(gdata$Score,2), 
                 groups = "top", top = 10, ylab = "Log2FC")
print(p1)
# Visualize negative selected genes.
gg = gdata[gdata$Score<0, ]
p2 = ScatterView(gg, x = "RandomIndex", y = "Score", label = "id",
                 y_cut = -CutoffCalling(gdata$Score,2), 
                 groups = "bottom", top = 10, ylab = "Log2FC")
print(p2)
gene_list <- c(gdata[1:10,1], gdata[(nrow(gdata)-9):nrow(gdata),1])
p2 = sgRankView(sdata, gene = gene_list, neg_ctrl = Neg_ctrl)
print(p2)

dev.off()

gdata = OmitCommonEssential(gdata)
sdata = OmitCommonEssential(sdata, symbol = "Gene")
# Compute the similarity with Depmap screens based on subset genes
depmap_similarity = ResembleDepmap(gdata, symbol = "id", score = "Score")
     
pdf(args[4], height = 9, width = 12)
# not remove essential genes
depmap_similarity = ResembleDepmap(gdata, symbol = "id", score = "Score")
gdata$LogFDR = -log10(gdata$FDR)
p2 = VolcanoView(gdata, x = "Score", y = "FDR", Label = "id", top = 10)
print(p2)
gdata$Rank = rank(gdata$Score)
p1 = ScatterView(gdata, x = "Rank", y = "Score", label = "id", 
                 top = 10, auto_cut_y = TRUE, ylab = "Log2FC", 
                 groups = c("top", "bottom"))
print(p1)
# Dot plot
gdata$RandomIndex = sample(1:nrow(gdata), nrow(gdata))
gdata = gdata[order(-gdata$Score), ]
# Visualize positive selected genes.
gg = gdata[gdata$Score>0, ]
p1 = ScatterView(gg, x = "RandomIndex", y = "Score", label = "id",
                 y_cut = CutoffCalling(gdata$Score,2), 
                 groups = "top", top = 10, ylab = "Log2FC")
print(p1)
# Visualize negative selected genes.
gg = gdata[gdata$Score<0, ]
p2 = ScatterView(gg, x = "RandomIndex", y = "Score", label = "id",
                 y_cut = -CutoffCalling(gdata$Score,2), 
                 groups = "bottom", top = 10, ylab = "Log2FC")
print(p2)
gene_list <- c(gdata[1:10,1], gdata[(nrow(gdata)-9):nrow(gdata),1])
p2 = sgRankView(sdata, gene = gene_list, neg_ctrl = Neg_ctrl)
print(p2)

dev.off()
