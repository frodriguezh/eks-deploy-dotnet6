FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ./*.sln ./
COPY ./aspnetcoreapp/*.csproj ./aspnetcoreapp/

RUN dotnet restore

COPY ./aspnetcoreapp/. ./aspnetcoreapp/

FROM build AS publish
WORKDIR /src/aspnetcoreapp
RUN dotnet publish -c Release -o /app --no-restore

FROM base AS run
WORKDIR /app
COPY --from=publish /app ./
ENTRYPOINT ["dotnet", "aspnetcoreapp.dll"]
