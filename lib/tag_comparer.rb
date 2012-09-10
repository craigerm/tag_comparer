# A comparison class that can be used to compare version numbers for software
# projects
module TagComparer
  extend self

  # These are the allowed version prefixes at this time 
  VERSION_PREFIXES = {
    'rc' => 100, 
    'beta' => 99, 
    'b' => 99,
    'alpha' => 98,
    'a' => 98,
    'v' => 1 # makes processing easier
  }

  # Compares a list of version numbers and returns the latest one based on
  # logical version numbering systems. Arguments can be arrays of strings
  # or just strings.
  #
  # ==== Examples
  #
  # get_latest('v1,'v2') # returns 'v2'
  # get_latest('v1.3.beta1', 'v1.3.beta2') # returns 'v1.3.beta2'
  # get_latest(['v1.3.beta1', 'v1.3.rc1', 'v1.3.alpha1']) # returns 'v1.3.rc1'
  def get_latest(*args)
    tags = []
    args.each do |a|
      if a.kind_of?(Array)
        tags.push(a)
      else
        tags.push(a)
      end
    end

    tags.flatten!

    latest_tag = tags.first

    tags.each do |tag|
        latest_tag = compare_items(latest_tag, tag) >= 0 ? latest_tag : tag
    end

    latest_tag
  end

  private

  def compare_items(first_tag, second_tag)

    first = get_version_parts(first_tag)
    second = get_version_parts(second_tag)

    length = [first.size, second.size].max

    for i in 0..length - 1 

      x = first[i] 
      y = second[i]

      if x == nil
        return -1 
      elsif y == nil
        return 1
      end

      if x.match(/\d/) == nil
        result = compare_text_versions(x, y)
        return result unless result == 0
        next
      end
     
      x = x.to_i
      y = y.to_i

      if x > y
        return 1
      elsif x < y
        return -1
      end
    end

    return 0
  end

  def compare_text_versions(a, b)
    prefix_a = VERSION_PREFIXES[a] || -1
    prefix_b = VERSION_PREFIXES[b] || -1

    if prefix_a > prefix_b
      1
    elsif prefix_a < prefix_b
      -1
    else 
      0
    end
  end

  def get_version_parts(version)
    version.scan(/([a-zA-Z]+|\d+{1,1})/).flatten
  end
end
