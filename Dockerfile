FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5010
ENV ASPNETCORE_URLS=http://*:5010

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DocketTest.csproj", "./"]
RUN dotnet restore "DocketTest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DocketTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DocketTest.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DocketTest.dll"]
