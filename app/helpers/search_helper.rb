module SearchHelper
	def get_results(result, term)
		return result.map{|t| t if t[:term] == term}.compact
	end

	def get_results_arm(result,arm)
		return result.map{|t| t if t[:arm_basic] == arm}.compact
	end
end
