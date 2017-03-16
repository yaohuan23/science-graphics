


data=read.table("diff_genumble_step_by");
png("./plot_result.png");
par(mar=c(6,6,6,6),lwd=3);
barplot(data[,1],space=0.5,xaxt="n",yaxt="n",xlab="Samples",ylab="Number of genes",xlim=c(0.25,10),ylim=c(0,400),col=c(rep("blue",length(data[,1]))));
axis(2,pos=0.25,at=c(0,150,400),labels=c("0","150","400"),las=1,tcl=-1.5,lwd=3,mgp=c(3,2,0),cex.axis=1);
axis(1,at=c(0.25,1.75,3.25),labels=c("","",""),tcl=-1.5,lwd=3,pos=0);
dev.off();
