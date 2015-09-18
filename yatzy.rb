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

  def fives
    Yatzy.compute_dies_score(@dice, 5)
  end

  def sixes
    Yatzy.compute_dies_score(@dice, 6)
  end

  def self.score_pair( d1,  d2,  d3,  d4,  d5)
    counts = [0]*6
    counts[d1-1] += 1
    counts[d2-1] += 1
    counts[d3-1] += 1
    counts[d4-1] += 1
    counts[d5-1] += 1
    at = 0
    (0...6).each do |at|
      if (counts[6-at-1] >= 2)
        return (6-at)*2
      end
    end
    return 0
  end

  def self.two_pair( d1,  d2,  d3,  d4,  d5)
    counts = [0]*6
    counts[d1-1] += 1
    counts[d2-1] += 1
    counts[d3-1] += 1
    counts[d4-1] += 1
    counts[d5-1] += 1
    n = 0
    score = 0
    for i in Array 0..5
      if (counts[6-i-1] >= 2)
        n = n+1
        score += (6-i)
      end
    end
    if (n == 2)
      return score * 2
    else
      return 0
    end
  end

  def self.four_of_a_kind( _1,  _2,  d3,  d4,  d5)
    tallies = [0]*6
    tallies[_1-1] += 1
    tallies[_2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1
    for i in (0..6)
      if (tallies[i] >= 4)
        return (i+1) * 4
      end
    end
    return 0
  end

  def self.three_of_a_kind( d1,  d2,  d3,  d4,  d5)
    t = [0]*6
    t[d1-1] += 1
    t[d2-1] += 1
    t[d3-1] += 1
    t[d4-1] += 1
    t[d5-1] += 1
    for i in [0,1,2,3,4,5]
      if (t[i] >= 3)
        return (i+1) * 3
      end
    end
    0
  end

  def self.smallStraight( d1,  d2,  d3,  d4,  d5)
    tallies = [0]*6
    tallies[d1-1] += 1
    tallies[d2-1] += 1
    tallies[d3-1] += 1
    tallies[d4-1] += 1
    tallies[d5-1] += 1
    (tallies[0] == 1 and
      tallies[1] == 1 and
      tallies[2] == 1 and
      tallies[3] == 1 and
      tallies[4] == 1) ? 15 : 0
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
end
