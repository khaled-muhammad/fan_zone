const League = require('../models/League');
const { success, created, notFound, badRequest, conflict } = require('../utils/response');

exports.getAllLeagues = async (req, res, next) => {
  try {
    const leagues = await League.find()
      .populate('teams', 'name')
      .populate('pitchId', 'name locationName');
    return success(res, 'Leagues retrieved', leagues);
  } catch (error) {
    next(error);
  }
};

exports.getLeagueById = async (req, res, next) => {
  try {
    const league = await League.findById(req.params.id)
      .populate('teams', 'name captainId players')
      .populate('pitchId', 'name locationName')
      .populate('standings.team', 'name')
      .populate('matches.homeTeam', 'name')
      .populate('matches.awayTeam', 'name');
    if (!league) return notFound(res, 'League not found');
    return success(res, 'League retrieved', league);
  } catch (error) {
    next(error);
  }
};

exports.createLeague = async (req, res, next) => {
  try {
    const { name, pitchId, startDate, maxTeams } = req.body;
    const league = await League.create({ name, pitchId, startDate, maxTeams });
    return created(res, 'League created', league);
  } catch (error) {
    next(error);
  }
};

exports.registerTeam = async (req, res, next) => {
  try {
    const league = await League.findById(req.params.id);
    if (!league) return notFound(res, 'League not found');

    const { teamId } = req.body;
    if (league.teams.includes(teamId)) {
      return conflict(res, 'Team already registered');
    }

    if (league.teams.length >= league.maxTeams) {
      return badRequest(res, 'League is full');
    }

    league.teams.push(teamId);
    league.standings.push({ team: teamId });
    await league.save();

    return success(res, 'Team registered to league', league);
  } catch (error) {
    next(error);
  }
};

exports.recordMatch = async (req, res, next) => {
  try {
    const league = await League.findById(req.params.id);
    if (!league) return notFound(res, 'League not found');

    const { homeTeam, awayTeam, homeScore, awayScore } = req.body;

    league.matches.push({
      homeTeam,
      awayTeam,
      homeScore,
      awayScore,
      played: true,
      date: new Date(),
    });

    const homeSt = league.standings.find((s) => s.team.toString() === homeTeam);
    const awaySt = league.standings.find((s) => s.team.toString() === awayTeam);

    if (homeSt && awaySt) {
      homeSt.played += 1;
      awaySt.played += 1;
      homeSt.goalsFor += homeScore;
      homeSt.goalsAgainst += awayScore;
      awaySt.goalsFor += awayScore;
      awaySt.goalsAgainst += homeScore;

      if (homeScore > awayScore) {
        homeSt.won += 1;
        homeSt.points += 3;
        awaySt.lost += 1;
      } else if (homeScore < awayScore) {
        awaySt.won += 1;
        awaySt.points += 3;
        homeSt.lost += 1;
      } else {
        homeSt.drawn += 1;
        awaySt.drawn += 1;
        homeSt.points += 1;
        awaySt.points += 1;
      }
    }

    await league.save();
    return success(res, 'Match recorded', league);
  } catch (error) {
    next(error);
  }
};
