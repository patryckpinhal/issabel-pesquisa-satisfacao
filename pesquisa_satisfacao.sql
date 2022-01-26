-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Tempo de geração: 25/01/2022 às 08:32
-- Versão do servidor: 5.5.68-MariaDB
-- Versão do PHP: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `pesquisa_satisfacao`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `missedcalls`
--

CREATE TABLE IF NOT EXISTS `missedcalls` (
  `id` int(11) NOT NULL,
  `call_id` varchar(45) DEFAULT NULL,
  `call_date` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pesquisa`
--

CREATE TABLE IF NOT EXISTS `pesquisa` (
  `id` int(100) NOT NULL,
  `call_date` datetime NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `call_queue` varchar(255) NOT NULL,
  `telephone` varchar(255) NOT NULL,
  `agent` varchar(255) NOT NULL,
  `response` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices de tabelas apagadas
--

--
-- Índices de tabela `missedcalls`
--
ALTER TABLE `missedcalls`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `pesquisa`
--
ALTER TABLE `pesquisa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- AUTO_INCREMENT de tabelas apagadas
--

--
-- AUTO_INCREMENT de tabela `missedcalls`
--
ALTER TABLE `missedcalls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de tabela `pesquisa`
--
ALTER TABLE `pesquisa`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
