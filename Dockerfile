
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

WORKDIR /app
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y libpng-dev libjpeg-dev curl libxi6 build-essential libgl1-mesa-glx
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y libpng-dev libjpeg-dev curl libxi6 build-essential libgl1-mesa-glx
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

WORKDIR /src
COPY . .
RUN dotnet restore "./NoticeBoardAPI/NoticeBoardAPI/notice-board.csproj" --disable-parallel

RUN dotnet build "./NoticeBoardAPI/NoticeBoardAPI/notice-board.csproj" -c release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "./NoticeBoardAPI/NoticeBoardAPI/notice-board.csproj" -c release -o /app/publish --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS="http://+:80"
EXPOSE 80
ENTRYPOINT ["dotnet", "notice-board.dll"]