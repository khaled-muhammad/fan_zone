const Team = require('../models/Team');
const { success, created, notFound, badRequest, conflict } = require('../utils/response');

exports.getAllTeams = async (req, res, next) => {
  try {
    const teams = await Team.find()
      .populate('captainId', 'fullName')
      .populate('players', 'fullName position level');
    return success(res, 'Teams retrieved', teams);
  } catch (error) {
    next(error);
  }
};

exports.getTeamById = async (req, res, next) => {
  try {
    const team = await Team.findById(req.params.id)
      .populate('captainId', 'fullName email')
      .populate('players', 'fullName position level matchesPlayed');
    if (!team) return notFound(res, 'Team not found');
    return success(res, 'Team retrieved', team);
  } catch (error) {
    next(error);
  }
};

exports.createTeam = async (req, res, next) => {
  try {
    const { name, maxPlayers } = req.body;
    const team = await Team.create({
      name,
      captainId: req.user._id,
      players: [req.user._id],
      maxPlayers: maxPlayers || 10,
    });
    return created(res, 'Team created', team);
  } catch (error) {
    next(error);
  }
};

exports.joinTeam = async (req, res, next) => {
  try {
    const team = await Team.findById(req.params.id);
    if (!team) return notFound(res, 'Team not found');

    if (team.players.includes(req.user._id)) {
      return conflict(res, 'Already a member of this team');
    }

    if (team.players.length >= team.maxPlayers) {
      return badRequest(res, 'Team is full');
    }

    team.players.push(req.user._id);
    await team.save();

    const populated = await team.populate('players', 'fullName position level');
    return success(res, 'Joined team successfully', populated);
  } catch (error) {
    next(error);
  }
};

exports.leaveTeam = async (req, res, next) => {
  try {
    const team = await Team.findById(req.params.id);
    if (!team) return notFound(res, 'Team not found');

    if (!team.players.includes(req.user._id)) {
      return badRequest(res, 'Not a member of this team');
    }

    if (team.captainId.toString() === req.user._id.toString()) {
      return badRequest(res, 'Captain cannot leave. Transfer captaincy first.');
    }

    team.players = team.players.filter(
      (p) => p.toString() !== req.user._id.toString()
    );
    await team.save();

    return success(res, 'Left team successfully', team);
  } catch (error) {
    next(error);
  }
};
