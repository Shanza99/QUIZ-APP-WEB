-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 18, 2025 at 08:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `quiz_app_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `attempts`
--

CREATE TABLE `attempts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `user_answer` char(1) DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT NULL,
  `attempt_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` int(11) NOT NULL,
  `question` text DEFAULT NULL,
  `option_a` varchar(255) DEFAULT NULL,
  `option_b` varchar(255) DEFAULT NULL,
  `option_c` varchar(255) DEFAULT NULL,
  `option_d` varchar(255) DEFAULT NULL,
  `correct_option` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `question`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`) VALUES
(1, 'Choose a word to take the place of the underlined word.', 'sheepes', 'sheepen', 'sheep', 'sheepses', 'C'),
(2, 'Choose a word to take the place of the underlined word.', 'childs', 'childes', 'children', 'childrens', 'C'),
(3, 'Choose a word to take the place of the underlined word.', 'footes', 'feets', 'feet', 'foots', 'C'),
(7, 'Choose a word to take the place of the underlined word.', 'sheepes', 'sheepen', 'sheep', 'sheepses', 'C'),
(8, 'Choose a word to take the place of the underlined word.', 'childs', 'childes', 'children', 'childrens', 'C'),
(9, 'Choose a word to take the place of the underlined word.', 'footes', 'feets', 'feet', 'foots', 'C');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`) VALUES
(1, 'o', 'j@gmail.com', '$2y$10$BuIsMx4M6zlMFBfRUIFXXu/0NGqpgaW3Yp7eANuVm4W54Z30DnIfW', '2025-10-18 15:35:33'),
(3, 'baihengg', 's@sgmail.com', '$2y$10$DHuBH1m4gFx92no9yylv6uC5CVkP77Ej1qHjyMSCOAR3aeoQ2qfg6', '2025-10-18 16:38:33'),
(4, 'xinsi', 'xinsi@gmail.com', '$2y$10$mYIrAMiK2VjNylA7EzJEje6Mp1452z2L/Jzl2AxOnLwSnOZp7agiO', '2025-10-18 16:42:26'),
(5, 'azn2', 'ex4@gmail.com', '$2y$10$ud3r4bTnNU0mwR.Z3SDPuejTIX7SG.SNiOJ6x9Oy6qFxzaljMDwim', '2025-10-18 17:03:47'),
(6, 'Shanza Batool', 'Shanza@gmail.com', '$2y$10$U3qJyoi63b3TylL3CWmL3eLFlUJDwOSoC/7y6w.HIQzoXgjJic3l.', '2025-10-18 17:19:30'),
(7, 's', 'srtt@gmail.com', '$2y$10$76wwHnNrugalH02tg95fpOF/BY6WWxrOQyyONPEan93xzdxTiMbyi', '2025-10-18 18:15:51');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attempts`
--
ALTER TABLE `attempts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attempts`
--
ALTER TABLE `attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
