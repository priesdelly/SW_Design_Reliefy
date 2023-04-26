using Mapster;
using MediatR;
using Reliefy.Application.BL.AvailableTime.Queries;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.AvailableTime.Commands;

public record CreateAvailableTimesCommand : IRequest<List<AvailableTimeDto>>
{
	public List<AvailableTimeDto> AvailableTimes { get; set; }
}

public class CreateAvailableTimesCommandHandler : IRequestHandler<CreateAvailableTimesCommand, List<AvailableTimeDto>>
{
	private readonly AvailableTimeService _availableTimeService;

	public CreateAvailableTimesCommandHandler(AvailableTimeService availableTimeService)
	{
		_availableTimeService = availableTimeService;
	}

	public async Task<List<AvailableTimeDto>> Handle(CreateAvailableTimesCommand request,
		CancellationToken cancellationToken)
	{
		var returnData = new List<Domain.Entities.AvailableTime>();
		foreach (var availableTime in request.AvailableTimes)
		{
			var entity = availableTime.Adapt<Domain.Entities.AvailableTime>();
			_availableTimeService.Add(entity);
			returnData.Add(entity);
		}

		await _availableTimeService.Save(cancellationToken);
		return returnData.Adapt<List<AvailableTimeDto>>();
	}
}