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
    pairs = extract_group(dies, 2)
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
    triplets = extract_group(dies, 3)
    pairs = extract_group(dies, 2)

    return 0 if pairs.empty? || triplets.empty?

    compute_group_score(pairs, 2) + compute_group_score(triplets, 3)
  end

  private
  def self.compute_score dies, die_value
    dies_with_value = dies.select {|die| die == die_value}
    die_value * dies_with_value.size
  end

  def self.compute_frequencies dies
    dies.inject({}) do |acc, d|
      if acc.include?(d)
        acc[d] += 1
      else
        acc.merge!({d => 1})
      end
      acc
    end
  end

  def self.extract_group dies, group_size
    compute_frequencies(dies).select do |die, frequencie|
      frequencie >= group_size
    end
  end

  def self.compute_group_of_a_kind_score dies, group_size
    group = extract_group(dies, group_size)
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
    first = dies.first
    dies.drop(1).all? {|die| die == first}
  end
end
