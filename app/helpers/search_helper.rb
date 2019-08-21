module SearchHelper
	def get_results(result, term)
		return result.map{|t| t if t[:term] == term}.compact
	end

	def get_results_arm(result,arm)
		return result.map{|t| t if t[:arm_basic] == arm}.compact
	end

	def closing_costs_filter(adjustment_pair)
		repeated_arr = []
		adj_data = {}
		adj_hash = {}
    adjustment_pair.to_a.map{|k, v| adj_data[k] = v if v!=0.0}
    puts "adj_data = #{adj_data}"
		if adj_data.keys.count<=5
			adj_data.to_a.each do |key, value|
				key_arr = key.split('/')
				assigned = false
				key_arr.each do |sub_key|
					if !repeated_arr.include?(sub_key) && !assigned
						repeated_arr << sub_key
						assigned = true
						if key_arr.length>=3
							adj_hash[sub_key] = value
						else
							adj_hash[key] = value
						end
					end
				end
				if (!assigned)
					adj_hash[key_arr[0]] = value
				end
			end
		else
			i = 0;
			other_value = 0;
			adj_data.to_a.each do |key, value|
				key_arr = key.split('/')
					assigned = false
					i = i+1
					if i<5	
						key_arr.each do |sub_key|
							if !repeated_arr.include?(sub_key) && !assigned
								repeated_arr << sub_key
								assigned = true
								if key_arr.length>=3
									adj_hash[sub_key] = value
								else
									adj_hash[key] = value
								end
							end
						end
						if (!assigned)
							adj_hash[key_arr[0]] = value
						end
					else
						other_value = other_value + value
						adj_hash['Other'] = other_value
					end
			end
		end
		puts "adj_hash = #{adj_hash}"
		return adj_hash.to_a
	end

	def adj_key_name(primary_key)
		key = ''
		arr = ["FICO", "LTV", "CLTV"]
		primary_key.split('/').map{|p| key = key+(arr.include?(p) ? p : p.titleize)+'/'}
		return key[0..-2]
	end
end