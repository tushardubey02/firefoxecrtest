ARG VERSION=8.0-noble-chiseled-extra
ARG SDKVERSION=8.0-noble

FROM mcr.microsoft.com/dotnet/aspnet:$VERSION AS base
ENV ASPNETCORE_HTTP_PORTS="8080" \
  ASPNETCORE_ENVIRONMENT="Development" \
  DOTNET_CLI_TELEMETRY_OPTOUT=1 \
  DOTNET_RUNNING_IN_CONTAINER="true" \
  DOTNET_SYSTEM_GLOBALIZATION_INVARIANT="0" 

EXPOSE 8080/tcp

FROM mcr.microsoft.com/dotnet/sdk:$SDKVERSION  AS build
WORKDIR /src

COPY "AIMIE3.sln" "AIMIE3.sln"
COPY "Directory.Build.props" "Directory.Build.props"
COPY "Directory.Packages.props" "Directory.Packages.props"
COPY "nuget.config" "nuget.config"
COPY "global.json" "global.json"

COPY "Aimie3.AppHost/Aimie3.AppHost.csproj" "Aimie3.AppHost/Aimie3.AppHost.csproj"
COPY "BlazorFrontEnd/BlazorFrontEnd.csproj" "BlazorFrontEnd/BlazorFrontEnd.csproj"

COPY "InternalApi/ApiCore/ApiCore.csproj" "InternalApi/ApiCore/ApiCore.csproj"
COPY "InternalApi/ApiModel/ApiModel.csproj" "InternalApi/ApiModel/ApiModel.csproj"

COPY "InternalApi/AgreementApi/AgreementApi.csproj" "InternalApi/AgreementApi/AgreementApi.csproj"
COPY "InternalApi/ClaimsApi/ClaimsApi.csproj" "InternalApi/ClaimsApi/ClaimsApi.csproj"
COPY "InternalApi/ComplaintsApi/ComplaintsApi.csproj" "InternalApi/ComplaintsApi/ComplaintsApi.csproj"
COPY "InternalApi/FinanceHistoryApi/FinanceHistoryApi.csproj" "InternalApi/FinanceHistoryApi/FinanceHistoryApi.csproj"
COPY "InternalApi/InvoiceApi/InvoiceApi.csproj" "InternalApi/InvoiceApi/InvoiceApi.csproj"
COPY "InternalApi/LesseeCancellationApi/LesseeCancellationApi.csproj" "InternalApi/LesseeCancellationApi/LesseeCancellationApi.csproj"
COPY "InternalApi/LessorConfigApi/LessorConfigApi.csproj" "InternalApi/LessorConfigApi/LessorConfigApi.csproj"
COPY "InternalApi/LessorManagementApi/LessorManagementApi.csproj" "InternalApi/LessorManagementApi/LessorManagementApi.csproj"
COPY "InternalApi/LetterApi/LetterApi.csproj" "InternalApi/LetterApi/LetterApi.csproj"
COPY "InternalApi/LookupApi/LookupApi.csproj" "InternalApi/LookupApi/LookupApi.csproj"
COPY "InternalApi/NotesApi/NotesApi.csproj" "InternalApi/NotesApi/NotesApi.csproj"
COPY "InternalApi/SearchApi/SearchApi.csproj" "InternalApi/SearchApi/SearchApi.csproj"
COPY "InternalApi/TasksApi/TasksApi.csproj" "InternalApi/TasksApi/TasksApi.csproj"

COPY "InternalServices/ApiHttpClientCommon/ApiHttpClientCommon/ApiHttpClientCommon.csproj" "InternalServices/ApiHttpClientCommon/ApiHttpClientCommon/ApiHttpClientCommon.csproj"
COPY "InternalServices/WorkflowService/WorkflowService.csproj" "InternalServices/WorkflowService/WorkflowService.csproj"

COPY "Tests/Directory.Build.props" "Tests/Directory.Build.props"
COPY "Tests/Frontend/BlazorFrontEndTests/BlazorFrontEndTests.csproj" "Tests/Frontend/BlazorFrontEndTests/BlazorFrontEndTests.csproj"
COPY "Tests/InternalApi/ApiTests/ApiTests.csproj" "Tests/InternalApi/ApiTests/ApiTests.csproj"
COPY "Tests/InternalServices/WorkflowServiceTests/WorkflowServiceTests.csproj" "Tests/InternalServices/WorkflowServiceTests/WorkflowServiceTests.csproj"

RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet restore "AIMIE3.sln"

COPY . .
WORKDIR /src/InternalApi/SearchApi
RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet publish SearchApi.csproj -r linux-x64 --no-restore -c Release --no-self-contained --property:PublishDir=/app /p:UseAppHost=false

FROM build AS publish

FROM base AS final
USER $APP_UID
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SearchApi.dll"]    