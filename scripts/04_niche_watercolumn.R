#################################################################################
#
#               Anaerobic Microbial Communities in a Stratified Sulfidic Lake
#                      
#              Rojas et al 2021.Organic electron donors and terminal electron 
#       acceptors structure anaerobic microbial communities and interactions in 
#                     a permanently stratified sulfidic lake
#
#                               By: Connie Rojas
#                               Created: 4 Aug 2020
#                            Last updated: 8 Feb 2021
################################################################################

## CODE FOR: generating niche breadth ~ abundance for each bacterial taxon
#niche breadth was calculated using Levin's (1968) niche breadth index 
#(WATER COLUMN data)

source(file="scripts/00_background.R"); #load necessary packages and specifications


################################################################################
#             1.  Read in your table of Levin's niche breadth values
################################################################################
niche=read.table("data/fgl_niche.txt", sep="\t", header=T);

#calculate +/- 1 SD from the mean niche breadth
MeanNiche=mean(niche$niche_breadth);
SDNiche=sd(niche$niche_breadth);
upper=MeanNiche+SDNiche;
lower=MeanNiche-SDNiche;


################################################################################
#             2.  Scatter of Levin's niche breadth vs. taxa abundance
################################################################################
#specialist and generalist bacterial taxa of interest are in color
#all other taxa are gray
#dashed lines denote boundaries for generalists or specialists

#set up color palette for points 
new_col=c('#66c2a5','#fc8d62','#7570b3','#e78ac3','#a6d854','#ffd92f',
          "#6baed6","#fc9272","#238b45","#08589e",
          "#bf812d");

#create a data frame that only contais the points that will be colored in the plot
niche2=niche[niche$colorcode!="Other",];

#plot!
niche_wc=ggplot()+ 
  geom_point(data=niche, aes(x = MeanRelAbund, y = niche_breadth),
             size=2,
             colour="#d9d9d9")+
  geom_point(data=niche2, aes(x =MeanRelAbund, y =niche_breadth,
                              colour =colorcode),
             size=2)+
  scale_colour_manual(values=new_col)+
  labs(y="Levin's niche breadth",
       x="Average Relative Abundance (log)",
       colour="")+
  geom_hline(yintercept=upper, linetype='dashed', col = 'black')+
  geom_hline(yintercept=lower, linetype='dashed', col = 'black')+
  theme_bw()+  
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(colour = "black", size=1),
        legend.position="right",
        legend.text=element_text(size=12),
        axis.text.x=element_text(size=12),
        axis.title.x=element_text(size=12, face="bold"), 
        axis.text.y=element_text(size=12),
        axis.title.y=element_text(size=12, face="bold"));

plot(niche_wc);

##save image 
ggsave(filename="04_WC_niche.pdf",
       device="pdf",path="./images",
       plot=niche_wc,
       width=6.5,
       height=4,
       units="in",
       dpi=400);
