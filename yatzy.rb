class Yatzy
  def self.chance(*dies)
    dies.reduce(:+)
  end

  def self.yatzy(dice)
    counts = [0]*(dice.length+1)
    for die in dice do
      counts[die-1] += 1
    end
    for i in 0..counts.size do
      if counts[i] == 5
        return 50
      end
    end
    return 0
  end

  def self.ones(*dies)
    compute_dies_score(dies, 1)
  end

  def self.twos(*dies)
    compute_dies_score(dies, 2)
  end

  def self.threes(*dies)
    compute_dies_score(dies, 3)
  end

  def initialize(*dies)
    @dice = dies
  end

  def self.fours(*dies)
    compute_dies_score(dies, 4)
  end

  def self.fives(*dies)
    compute_dies_score(dies, 5)
  end

  def self.sixes(*dies)
    compute_dies_score(dies, 6)
  end

  def self.score_pair(*dies)
    group_of_a_kind(dies, 2)
  end

  def self.two_pair(*dies)
    pairs = extract_group(dies, 2)
    pairs.keys.reduce(:+) * 2
  end

  def self.four_of_a_kind(*dies)
    group_of_a_kind(dies, 4)
  end

  def self.three_of_a_kind(*dies)
    group_of_a_kind(dies, 3)
  end

  def self.smallStraight(*dies)
    is_small_straight = frequencies(dies).all? do |die, frequency|
      frequency == 1
    end

    return 15 if is_small_straight

    return 0

    # tallies = [0]*6
    # tallies[d1-1] += 1
    # tallies[d2-1] += 1
    # tallies[d3-1] += 1
    # tallies[d4-1] += 1
    # tallies[d5-1] += 1
    # (tallies[0] == 1 and
    #   tallies[1] == 1 and
    #   tallies[2] == 1 and
    #   tallies[3] == 1 and
    #   tallies[4] == 1) ? 15 : 0
  end

  def self.largeStraight( d1,  d2,  d3,  d4,  d5)
    tallies = [0]*6
    tallies[d1-1] += 1
    tallies[d2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1
    if (tallies[1] == 1 and tallies[2] == 1 and tallies[3] == 1 and tallies[4] == 1 and tallies[5] == 1)
      return 20
    end
    return 0
  end

  def self.fullHouse( d1,  d2,  d3,  d4,  d5)
    tallies = []
    _2 = false
    i = 0
    _2_at = 0
    _3 = false
    _3_at = 0

    tallies = [0]*6
    tallies[d1-1] += 1
    tallies[d2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1

    for i in Array 0..5
      if (tallies[i] == 2)
        _2 = true
        _2_at = i+1
      end
    end

    for i in Array 0..5
      if (tallies[i] == 3)
        _3 = true
        _3_at = i+1
      end
    end

    if (_2 and _3)
      return _2_at * 2 + _3_at * 3
    else
      return 0
    end
  end

  private
  def self.compute_dies_score(dies, die_value)
    die_value * dies.select {|die| die == die_value}.size
  end

  def self.frequencies dies
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
    frequencies(dies).select do |die, frequencie|
      frequencie >= group_size
    end
  end

  def self.group_of_a_kind dies, group_size
    pairs = extract_group(dies, group_size)
    (pairs.keys.max || 0) * group_size
  end
end
