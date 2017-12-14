using DataFrames
using PyPlot
using PyCall
@pyimport matplotlib.patches as mpatches

function makeFig2Figs()
	close("all")
	df = readtable("../DOPS_Results/performanceComparsion.csv")
	colors = ["#000000","#708090" , "#696969", "#A9A9A9", "#DCDCDC"]
	optmethod = ["SA","PSO", "DE", "DOPS", "DDS"]
	legend_patches = []
	cmap=ColorMap("gray")
	df=hcat(df, ["" for r in 1:size(df,1)]) #adding column for color
	rename!(df, [:x1], [:barcolor])
	#fill in the colors
	for k in collect(1:size(df,1))
		if(df[:opt_method][k]=="SA")
			df[:barcolor][k]=colors[1] #cmap(1)
		elseif(df[:opt_method][k]=="PSO")
			df[:barcolor][k]=colors[2] #cmap(1)
		elseif(df[:opt_method][k]=="DE")
			df[:barcolor][k]=colors[3] #cmap(1)
		elseif(df[:opt_method][k]=="Z_DOPS") #to force at the end when sorting
			df[:barcolor][k]=colors[4]
		elseif(df[:opt_method][k]=="DDS")
			df[:barcolor][k]=colors[5]
		end
	end

	for k in collect(1:size(colors,1))
		push!(legend_patches,mpatches.Patch(color=colors[k], label=optmethod[k]))
	end

	
	@show df
	@show size(legend_patches)
	alllimits = [[.5,16,0,1.3],[.5,16,0,1.3], [.5,16,0,1.3]]
	functions = ["ackley_10d", "rast_10d", "rast_300d"]
	xlabels = ["40 Evaluations", "2000 Evaluations", "4000 Evaluations"]
	count = 1
	for f in functions
		reldata = df[df[:_function].==f,:]
		reldata = sort!(reldata, cols = [order(:num_evals), order(:opt_method)])
		figure(figsize=[15,7.5])
		bar(collect(1:size(reldata,1)), reldata[:avg_scaled_err], yerr=reldata[:std_scaled_err], color=reldata[:barcolor],ecolor="k")
		#title(f, fontsize=20)
		ylabel("Scaled Error (mean+std)", fontsize=30)
		ax=gca()
		axis(alllimits[count])
		ax[:tick_params]("both",labelsize=24) 
		legend(handles = legend_patches)
		ax[:set_xticks]([3,8,13])
		ax[:xaxis][:set_ticklabels](xlabels)
		savefig(string("../DOPS_Results/figures/",f, ".png"))
		count = count+1
	end
	return df
end
