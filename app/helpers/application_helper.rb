=begin
  Developer:      Varun
  Purpose:        for definning common functions 
=end
module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def meta_description(blog_text)
    content_for(:meta_description) { blog_text }
  end
  
  #function for getting users location 
  def user_location_info
    if current_user.present? && current_user.current_sign_in_ip != "127.0.0.1"
      @user_info = Geocoder.search(current_user.current_sign_in_ip).first
    elsif request.remote_ip != "127.0.0.1"
      @user_info = Geocoder.search(request.remote_ip).first 
     # else         #static ip for unit testing 
     #   @user_info= Geocoder.search("213.180.204.26").first
    end   
    return @user_info
  end

  #mappping state code with state name
  def state_full_name(state_code,flag = false)
    state = {
      'AL' => 'Alabama',
      'AK' => 'Alaska',
      'AS' => 'America Samoa',
      'AZ' => 'Arizona',
      'AR' => 'Arkansas',
      'CA' => 'California',
      'CO' => 'Colorado',
      'CT' => 'Connecticut',
      'DE' => 'Delaware',
      'DC' => 'District of Columbia',
      'FM' => 'Micronesia1',
      'FL' => 'Florida',
      'GA' => 'Georgia',
      'GU' => 'Guam',
      'HI' => 'Hawaii',
      'ID' => 'Idaho',
      'IL' => 'Illinois',
      'IN' => 'Indiana',
      'IA' => 'Iowa',
      'KS' => 'Kansas',
      'KY' => 'Kentucky',
      'LA' => 'Louisiana',
      'ME' => 'Maine',
      'MH' => 'Islands1',
      'MD' => 'Maryland',
      'MA' => 'Massachusetts',
      'MI' => 'Michigan',
      'MN' => 'Minnesota',
      'MS' => 'Mississippi',
      'MO' => 'Missouri',
      'MT' => 'Montana',
      'NE' => 'Nebraska',
      'NV' => 'Nevada',
      'NH' => 'New Hampshire',
      'NJ' => 'New Jersey',
      'NM' => 'New Mexico',
      'NY' => 'New York',
      'NC' => 'North Carolina',
      'ND' => 'North Dakota',
      'OH' => 'Ohio',
      'OK' => 'Oklahoma',
      'OR' => 'Oregon',
      'PW' => 'Palau',
      'PA' => 'Pennsylvania',
      'PR' => 'Puerto Rico',
      'RI' => 'Rhode Island',
      'SC' => 'South Carolina',
      'SD' => 'South Dakota',
      'TN' => 'Tennessee',
      'TX' => 'Texas',
      'UT' => 'Utah',
      'VT' => 'Vermont',
      'VI' => 'Virgin Island',
      'VA' => 'Virginia',
      'WA' => 'Washington',
      'WV' => 'West Virginia',
      'WI' => 'Wisconsin',
      'WY' => 'Wyoming'
    }
    code = if flag
      state.key(state_code).present? ? state.key(state_code) : state_code
    else
      state[state_code.upcase].present? ? state[state_code] : state_code
    end
    return code 
  end

  #per page link calculation
  def link_calculate(count)
      num_chunks = (count**0.5).ceil
      min_links_in_chunk = (count/num_chunks).floor  if num_chunks > 0
      max_links = min_links_in_chunk + 1        if min_links_in_chunk.present?
      return max_links 
  end

  #for removing special chars and space 
  def customize_path(first, last)
    #return  (first.gsub(/[.!@%&"]/,'').squeeze(" ").tr(" ",'+')+ '_'+last.gsub(/[.!@%&"]/,' ').squeeze(" ").tr(" ",'+')).split('+').map(&:capitalize)*'+'
    return  (first.gsub(/[.!@%&"]/,'').squeeze(" ").tr(" ",'+').split('+').map(&:capitalize)*'+' + '_'+last.gsub(/[.!@%&"]/,' ').squeeze(" ").tr(" ",'+').split('+').map(&:capitalize)*'+')
  end


  def custom_path(name)
    return  (name.gsub(/[.!@%&"]/,'').squeeze(" ").tr(" ",'+')).split('+').map(&:capitalize)*'+'
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
