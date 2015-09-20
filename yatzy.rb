class Yatzy
  def self.chance *dies
    dies.reduce(:+)
  end

  def self.yatzy *dies
    return 50 if all_equal?(dies)
    return 0
  end

  def self.ones *dies
    compute_score(dies, 1)
  end

  def self.twos *dies
    compute_score(dies, 2)
  end

  def self.threes *dies
    compute_score(dies, 3)
  end

  def self.fours *dies
    compute_score(dies, 4)
  end

  def self.fives *dies
    compute_score(dies, 5)
  end

  def self.sixes *dies
    compute_score(dies, 6)
  end

  def self.one_pair *dies
    compute_group_of_a_kind_score(dies, 2)
  end

  def self.two_pairs *dies
    pairs = extract_group_with_equal_or_larger_size(dies, 2)
    pairs.keys.reduce(:+) * 2
  end

  def self.four_of_a_kind *dies
    compute_group_of_a_kind_score(dies, 4)
  end

  def self.three_of_a_kind *dies
    compute_group_of_a_kind_score(dies, 3)
  end

  def self.small_straight *dies
    return 15 if small_straight?(dies)
    return 0
  end

  def self.large_straight *dies
    return 20 if large_straight?(dies)
    return 0
  end

  def self.full_house *dies
    return 0 unless full_house?(dies)
    compute_full_house_score(dies)
  end

  private
  def self.compute_score dies, die_value
    dies_with_value = dies.select {|die| die == die_value}
    die_value * dies_with_value.size
  end

  def self.compute_frequencies dies
    dies.inject({}) do |frequencies_so_far, die|
      if frequencies_so_far.include?(die)
        frequencies_so_far[die] += 1
      else
        frequencies_so_far.merge!({die => 1})
      end
      frequencies_so_far
    end
  end

  def self.extract_group_with_equal_or_larger_size dies, group_size
    extract_group(
      dies,
      lambda { |frequency| frequency >= group_size }
    )
  end

  def self.compute_group_of_a_kind_score dies, group_size
    group = extract_group_with_equal_or_larger_size(dies, group_size)
    compute_group_score(group, group_size)
  end

  def self.compute_group_score group, group_size
    (group.keys.max || 0) * group_size
  end

  def self.small_straight? dies
    frequencies = compute_frequencies(dies)
    frequencies.all? do |die, frequency|
      frequency == 1 && die != 6
    end
  end

  def self.large_straight? dies
    frequencies = compute_frequencies(dies)
    frequencies.all? do |die, frequency|
      frequency == 1 && die != 1
    end
  end

  def self.all_equal? dies
    dies.uniq.size == 1
  end

  def self.compute_full_house_score dies
    pairs_score = compute_full_house_group(dies, 2)
    triplets_score = compute_full_house_group(dies, 3)
    pairs_score + triplets_score
  end

  def self.full_house? dies
    triplets = extract_group_with_equal_size(dies, 3)
    pairs = extract_group_with_equal_size(dies, 2)

    only_one_pair = pairs.size == 1
    only_one_triplet = triplets.size == 1
    only_one_pair && only_one_triplet
  end

  def self.extract_group_with_equal_size dies, group_size
    extract_group(dies, lambda { |frequency| frequency == group_size })
  end

  def self.compute_full_house_group dies, group_size
    group = extract_group_with_equal_size(dies, group_size)
    compute_group_score(group, group_size)
  end

  def self.extract_group dies, pred
    compute_frequencies(dies).select do |_, frequency|
      pred.call(frequency)
    end
  end
end
